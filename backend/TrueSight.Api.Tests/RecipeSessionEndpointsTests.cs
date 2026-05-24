using System.Net;
using TrueSight.Api.Tests.Support;

namespace TrueSight.Api.Tests;

public sealed class RecipeSessionEndpointsTests(TrueSightWebApplicationFactory factory) : IClassFixture<TrueSightWebApplicationFactory>
{
    [Fact]
    public async Task AcceptRecipe_deducts_required_inventory()
    {
        var client = factory.CreateClient().ForUser($"recipe-session-{Guid.NewGuid():N}");

        await CreateInventoryItem(client, "Chicken", 300, "g");
        await CreateInventoryItem(client, "Spinach", 120, "g");
        await CreateInventoryItem(client, "Eggs", 2, "count");

        var acceptResponse = await client.PostJsonAsync("/api/recipe-sessions", new
        {
            recipeId = "chicken-spinach-eggs",
            servingMultiplier = 1,
        });

        Assert.Equal(HttpStatusCode.Created, acceptResponse.StatusCode);

        var session = await acceptResponse.ReadJsonAsync<RecipeSessionDto>();
        Assert.NotNull(session);
        Assert.Equal("chicken-spinach-eggs", session.RecipeId);
        Assert.Equal("Chicken Spinach Scramble", session.RecipeName);
        Assert.Equal(3, session.Lines.Count);

        var inventoryResponse = await client.GetAsync("/api/inventory");
        var inventory = await inventoryResponse.ReadJsonAsync<List<InventoryItemDto>>();
        Assert.NotNull(inventory);
        Assert.All(inventory, item => Assert.Equal(0m, item.Quantity));

        var sessionsResponse = await client.GetAsync("/api/recipe-sessions");
        Assert.Equal(HttpStatusCode.OK, sessionsResponse.StatusCode);

        var sessions = await sessionsResponse.ReadJsonAsync<List<RecipeSessionDto>>();
        Assert.NotNull(sessions);
        Assert.Single(sessions);
        Assert.Equal(session.Id, sessions[0].Id);
    }

    [Fact]
    public async Task AcceptRecipe_defaults_serving_multiplier_when_omitted()
    {
        var client = factory.CreateClient().ForUser($"recipe-session-default-{Guid.NewGuid():N}");

        await CreateInventoryItem(client, "Chicken", 300, "g");
        await CreateInventoryItem(client, "Spinach", 120, "g");
        await CreateInventoryItem(client, "Eggs", 2, "count");

        var acceptResponse = await client.PostJsonAsync("/api/recipe-sessions", new { recipeId = "chicken-spinach-eggs" });

        Assert.Equal(HttpStatusCode.Created, acceptResponse.StatusCode);

        var session = await acceptResponse.ReadJsonAsync<RecipeSessionDto>();
        Assert.NotNull(session);
        Assert.Equal(1m, session.ServingMultiplier);
    }

    [Fact]
    public async Task AcceptRecipe_returns_bad_request_when_inventory_is_insufficient()
    {
        var client = factory.CreateClient().ForUser($"recipe-session-fail-{Guid.NewGuid():N}");

        await CreateInventoryItem(client, "Eggs", 1, "count");

        var acceptResponse = await client.PostJsonAsync("/api/recipe-sessions", new
        {
            recipeId = "chicken-spinach-eggs",
            servingMultiplier = 1,
        });

        Assert.Equal(HttpStatusCode.BadRequest, acceptResponse.StatusCode);
    }

    private static async Task CreateInventoryItem(HttpClient client, string name, decimal quantity, string unit)
    {
        var response = await client.PostJsonAsync("/api/inventory", new
        {
            name,
            quantity,
            unit,
            expiryDate = (string?)null,
        });

        response.EnsureSuccessStatusCode();
    }

    private sealed record InventoryItemDto(
        Guid Id,
        string Name,
        decimal Quantity,
        string Unit,
        DateOnly? ExpiryDate,
        DateTimeOffset AddedAt,
        DateTimeOffset UpdatedAt);

    private sealed record RecipeSessionDto(
        Guid Id,
        string RecipeId,
        string RecipeName,
        decimal ServingMultiplier,
        DateTimeOffset AcceptedAt,
        List<RecipeSessionLineDto> Lines);

    private sealed record RecipeSessionLineDto(string IngredientName, decimal QuantityDeducted, string Unit);
}
