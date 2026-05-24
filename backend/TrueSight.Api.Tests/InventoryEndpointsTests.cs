using System.Net;
using TrueSight.Api.Tests.Support;

namespace TrueSight.Api.Tests;

public sealed class InventoryEndpointsTests(TrueSightWebApplicationFactory factory) : IClassFixture<TrueSightWebApplicationFactory>
{
    [Fact]
    public async Task InventoryCrud_round_trips_item()
    {
        var client = factory.CreateClient().ForUser($"inventory-crud-{Guid.NewGuid():N}");

        var createResponse = await client.PostJsonAsync("/api/inventory", new
        {
            name = "Spinach",
            quantity = 2.5m,
            unit = "g",
            expiryDate = "2026-06-01",
        });

        Assert.Equal(HttpStatusCode.Created, createResponse.StatusCode);

        var created = await createResponse.ReadJsonAsync<InventoryItemDto>();
        Assert.NotNull(created);
        Assert.Equal("Spinach", created.Name);
        Assert.Equal(2.5m, created.Quantity);
        Assert.Equal("g", created.Unit);
        Assert.Equal(DateOnly.Parse("2026-06-01"), created.ExpiryDate);

        var listResponse = await client.GetAsync("/api/inventory");
        Assert.Equal(HttpStatusCode.OK, listResponse.StatusCode);

        var items = await listResponse.ReadJsonAsync<List<InventoryItemDto>>();
        Assert.NotNull(items);
        Assert.Single(items);
        Assert.Equal(created.Id, items[0].Id);

        var getResponse = await client.GetAsync($"/api/inventory/{created.Id}");
        Assert.Equal(HttpStatusCode.OK, getResponse.StatusCode);

        var fetched = await getResponse.ReadJsonAsync<InventoryItemDto>();
        Assert.NotNull(fetched);
        Assert.Equal("Spinach", fetched.Name);

        var updateResponse = await client.PutJsonAsync($"/api/inventory/{created.Id}", new
        {
            name = "Baby Spinach",
            quantity = 1m,
            unit = "kg",
            expiryDate = (string?)null,
        });

        Assert.Equal(HttpStatusCode.OK, updateResponse.StatusCode);

        var updated = await updateResponse.ReadJsonAsync<InventoryItemDto>();
        Assert.NotNull(updated);
        Assert.Equal("Baby Spinach", updated.Name);
        Assert.Equal(1m, updated.Quantity);
        Assert.Equal("kg", updated.Unit);
        Assert.Null(updated.ExpiryDate);

        var deleteResponse = await client.DeleteAsync($"/api/inventory/{created.Id}");
        Assert.Equal(HttpStatusCode.NoContent, deleteResponse.StatusCode);

        var missingResponse = await client.GetAsync($"/api/inventory/{created.Id}");
        Assert.Equal(HttpStatusCode.NotFound, missingResponse.StatusCode);
    }

    [Fact]
    public async Task InventoryItem_is_isolated_per_user()
    {
        var userA = factory.CreateClient().ForUser($"inventory-user-a-{Guid.NewGuid():N}");
        var userB = factory.CreateClient().ForUser($"inventory-user-b-{Guid.NewGuid():N}");

        var createResponse = await userA.PostJsonAsync("/api/inventory", new
        {
            name = "Milk",
            quantity = 1m,
            unit = "l",
            expiryDate = (string?)null,
        });

        Assert.Equal(HttpStatusCode.Created, createResponse.StatusCode);
        var created = await createResponse.ReadJsonAsync<InventoryItemDto>();
        Assert.NotNull(created);

        Assert.Equal(HttpStatusCode.NotFound, (await userB.GetAsync($"/api/inventory/{created.Id}")).StatusCode);

        Assert.Equal(HttpStatusCode.NotFound, (await userB.PutJsonAsync($"/api/inventory/{created.Id}", new
        {
            name = "Stolen Milk",
            quantity = 9m,
            unit = "l",
            expiryDate = (string?)null,
        })).StatusCode);

        Assert.Equal(HttpStatusCode.NotFound, (await userB.DeleteAsync($"/api/inventory/{created.Id}")).StatusCode);

        var listResponse = await userA.GetAsync("/api/inventory");
        var items = await listResponse.ReadJsonAsync<List<InventoryItemDto>>();
        Assert.NotNull(items);
        Assert.Single(items);
        Assert.Equal(created.Id, items[0].Id);
    }

    [Fact]
    public async Task CreateInventoryItem_rejects_unknown_unit()
    {
        var client = factory.CreateClient().ForUser($"inventory-validation-{Guid.NewGuid():N}");

        var response = await client.PostJsonAsync("/api/inventory", new
        {
            name = "Milk",
            quantity = 1m,
            unit = "gallon",
            expiryDate = (string?)null,
        });

        Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
    }

    private sealed record InventoryItemDto(
        Guid Id,
        string Name,
        decimal Quantity,
        string Unit,
        DateOnly? ExpiryDate,
        DateTimeOffset AddedAt,
        DateTimeOffset UpdatedAt);
}
