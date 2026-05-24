using System.Net;
using TrueSight.Api.Tests.Support;

namespace TrueSight.Api.Tests;

public sealed class ShoppingListEndpointsTests(TrueSightWebApplicationFactory factory)
    : IClassFixture<TrueSightWebApplicationFactory>
{
    [Fact]
    public async Task ShoppingList_crud_and_move_merges_into_inventory()
    {
        var client = factory.CreateClient().ForUser($"shopping-list-{Guid.NewGuid():N}");

        var createResponse = await client.PostJsonAsync("/api/shopping-list", new
        {
            name = "Spinach",
            quantity = 2m,
            unit = "g",
            sourceRecipeId = (string?)null,
        });

        Assert.Equal(HttpStatusCode.Created, createResponse.StatusCode);

        var created = await createResponse.ReadJsonAsync<ShoppingListItemDto>();
        Assert.NotNull(created);
        Assert.Equal("Spinach", created.Name);
        Assert.Equal(2m, created.Quantity);

        var mergeResponse = await client.PostJsonAsync("/api/shopping-list", new
        {
            name = "spinach",
            quantity = 1m,
            unit = "g",
            sourceRecipeId = "vegetable-omelette",
        });

        Assert.Equal(HttpStatusCode.Created, mergeResponse.StatusCode);
        var merged = await mergeResponse.ReadJsonAsync<ShoppingListItemDto>();
        Assert.NotNull(merged);
        Assert.Equal(created.Id, merged.Id);
        Assert.Equal(3m, merged.Quantity);
        Assert.Equal("vegetable-omelette", merged.SourceRecipeId);

        var listResponse = await client.GetAsync("/api/shopping-list");
        Assert.Equal(HttpStatusCode.OK, listResponse.StatusCode);
        var items = await listResponse.ReadJsonAsync<List<ShoppingListItemDto>>();
        Assert.NotNull(items);
        Assert.Single(items);

        var moveResponse = await client.PostJsonAsync($"/api/shopping-list/{created.Id}/move-to-inventory", new
        {
            expiryDate = "2026-06-15",
        });

        Assert.Equal(HttpStatusCode.OK, moveResponse.StatusCode);
        var inventoryItem = await moveResponse.ReadJsonAsync<InventoryItemDto>();
        Assert.NotNull(inventoryItem);
        Assert.Equal(3m, inventoryItem.Quantity);
        Assert.Equal(DateOnly.Parse("2026-06-15"), inventoryItem.ExpiryDate);

        Assert.Empty(await (await client.GetAsync("/api/shopping-list")).ReadJsonAsync<List<ShoppingListItemDto>>() ?? []);

        var inventory = await (await client.GetAsync("/api/inventory")).ReadJsonAsync<List<InventoryItemDto>>();
        Assert.NotNull(inventory);
        Assert.Single(inventory);
        Assert.Equal(inventoryItem.Id, inventory[0].Id);
    }

    [Fact]
    public async Task ShoppingListItem_is_isolated_per_user()
    {
        var userA = factory.CreateClient().ForUser($"shopping-user-a-{Guid.NewGuid():N}");
        var userB = factory.CreateClient().ForUser($"shopping-user-b-{Guid.NewGuid():N}");

        var createResponse = await userA.PostJsonAsync("/api/shopping-list", new
        {
            name = "Milk",
            quantity = 1m,
            unit = "l",
            sourceRecipeId = (string?)null,
        });

        var created = await createResponse.ReadJsonAsync<ShoppingListItemDto>();
        Assert.NotNull(created);

        Assert.Equal(HttpStatusCode.NotFound, (await userB.DeleteAsync($"/api/shopping-list/{created.Id}")).StatusCode);
        Assert.Equal(
            HttpStatusCode.NotFound,
            (await userB.PostJsonAsync($"/api/shopping-list/{created.Id}/move-to-inventory", new { expiryDate = (string?)null }))
                .StatusCode);

        var list = await userA.GetAsync("/api/shopping-list");
        var items = await list.ReadJsonAsync<List<ShoppingListItemDto>>();
        Assert.NotNull(items);
        Assert.Single(items);
    }

    [Fact]
    public async Task DeleteShoppingListItem_returns_not_found_for_missing_row()
    {
        var client = factory.CreateClient().ForUser($"shopping-delete-{Guid.NewGuid():N}");

        Assert.Equal(HttpStatusCode.NotFound, (await client.DeleteAsync($"/api/shopping-list/{Guid.NewGuid()}")).StatusCode);
    }

    private sealed record ShoppingListItemDto(
        Guid Id,
        string Name,
        decimal Quantity,
        string Unit,
        string? SourceRecipeId,
        DateTimeOffset CreatedAt);

    private sealed record InventoryItemDto(
        Guid Id,
        string Name,
        decimal Quantity,
        string Unit,
        DateOnly? ExpiryDate,
        DateTimeOffset AddedAt,
        DateTimeOffset UpdatedAt);
}
