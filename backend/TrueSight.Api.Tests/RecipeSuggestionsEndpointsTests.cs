using System.Net;
using System.Text.Json;
using TrueSight.Api.Tests.Support;

namespace TrueSight.Api.Tests;

public sealed class RecipeSuggestionsEndpointsTests(TrueSightWebApplicationFactory factory) : IClassFixture<TrueSightWebApplicationFactory>
{
    [Fact]
    public async Task GetSuggestions_returns_ingredient_lines_and_canCook()
    {
        var client = factory.CreateClient().ForUser($"recipe-suggestions-{Guid.NewGuid():N}");

        await client.PostJsonAsync("/api/inventory", new
        {
            name = "Eggs",
            quantity = 4m,
            unit = "count",
            expiryDate = (string?)null,
        });
        await client.PostJsonAsync("/api/inventory", new { name = "Spinach", quantity = 60m, unit = "g", expiryDate = (string?)null });
        await client.PostJsonAsync("/api/inventory", new { name = "Cheese", quantity = 30m, unit = "g", expiryDate = (string?)null });
        await client.PostJsonAsync("/api/inventory", new { name = "Tomato", quantity = 1m, unit = "count", expiryDate = (string?)null });

        var response = await client.GetAsync("/api/recipes/suggestions");
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);

        await using var stream = await response.Content.ReadAsStreamAsync();
        using var document = await JsonDocument.ParseAsync(stream);
        var omelette = document.RootElement.EnumerateArray()
            .Single(element => element.GetProperty("id").GetString() == "vegetable-omelette");

        Assert.True(omelette.GetProperty("canCook").GetBoolean());
        Assert.Equal(0, omelette.GetProperty("missingIngredientCount").GetInt32());

        var eggs = omelette.GetProperty("ingredients").EnumerateArray()
            .Single(element => element.GetProperty("name").GetString() == "eggs");
        Assert.Equal(2m, eggs.GetProperty("requiredQuantity").GetDecimal());
        Assert.Equal(4m, eggs.GetProperty("inStockQuantity").GetDecimal());
        Assert.Equal("sufficient", eggs.GetProperty("status").GetString());
    }

    [Fact]
    public async Task GetSuggestions_sets_canCook_false_when_required_stock_is_short()
    {
        var client = factory.CreateClient().ForUser($"recipe-suggestions-short-{Guid.NewGuid():N}");

        await client.PostJsonAsync("/api/inventory", new
        {
            name = "Eggs",
            quantity = 1m,
            unit = "count",
            expiryDate = (string?)null,
        });

        var response = await client.GetAsync("/api/recipes/suggestions");
        var document = await ReadJsonDocument(response);

        var omelette = document.RootElement.EnumerateArray()
            .Single(element => element.GetProperty("id").GetString() == "vegetable-omelette");

        Assert.False(omelette.GetProperty("canCook").GetBoolean());
        Assert.True(omelette.GetProperty("missingIngredientCount").GetInt32() > 0);
    }

    [Fact]
    public async Task GetRecipe_returns_detail_for_known_id()
    {
        var client = factory.CreateClient().ForUser($"recipe-detail-{Guid.NewGuid():N}");

        var response = await client.GetAsync("/api/recipes/vegetable-omelette");
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);

        var document = await ReadJsonDocument(response);
        Assert.Equal("vegetable-omelette", document.RootElement.GetProperty("id").GetString());
        Assert.True(document.RootElement.GetProperty("ingredients").GetArrayLength() > 0);
    }

    [Fact]
    public async Task GetRecipe_returns_not_found_for_unknown_id()
    {
        var client = factory.CreateClient().ForUser($"recipe-missing-{Guid.NewGuid():N}");

        var response = await client.GetAsync("/api/recipes/does-not-exist");
        Assert.Equal(HttpStatusCode.NotFound, response.StatusCode);
    }

    [Fact]
    public async Task GetSuggestions_does_not_leak_other_users_inventory()
    {
        var userA = factory.CreateClient().ForUser($"recipe-user-a-{Guid.NewGuid():N}");
        var userB = factory.CreateClient().ForUser($"recipe-user-b-{Guid.NewGuid():N}");

        await userA.PostJsonAsync("/api/inventory", new
        {
            name = "Eggs",
            quantity = 4m,
            unit = "count",
            expiryDate = (string?)null,
        });

        var response = await userB.GetAsync("/api/recipes/suggestions");
        var document = await ReadJsonDocument(response);

        var omelette = document.RootElement.EnumerateArray()
            .Single(element => element.GetProperty("id").GetString() == "vegetable-omelette");

        Assert.False(omelette.GetProperty("canCook").GetBoolean());
    }

    private static async Task<JsonDocument> ReadJsonDocument(HttpResponseMessage response)
    {
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        await using var stream = await response.Content.ReadAsStreamAsync();
        return await JsonDocument.ParseAsync(stream);
    }
}
