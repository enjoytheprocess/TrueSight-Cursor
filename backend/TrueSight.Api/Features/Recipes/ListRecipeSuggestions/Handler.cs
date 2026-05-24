using MediatR;
using Microsoft.EntityFrameworkCore;
using TrueSight.Api.Infrastructure;
using TrueSight.Api.Infrastructure.Data;
using TrueSight.Api.Infrastructure.Recipes;
using TrueSight.Api.Shared;

namespace TrueSight.Api.Features.Recipes.ListRecipeSuggestions;

public sealed class Handler(TrueSightDbContext db, ICurrentUser currentUser, IRecipeProvider provider)
    : IRequestHandler<ListRecipeSuggestionsQuery, IReadOnlyList<RecipeSuggestionResponse>>
{
    public async Task<IReadOnlyList<RecipeSuggestionResponse>> Handle(ListRecipeSuggestionsQuery request, CancellationToken cancellationToken)
    {
        var inventory = await db.InventoryItems
            .AsNoTracking()
            .Where(item => item.UserId == currentUser.UserId && item.Quantity > 0)
            .ToListAsync(cancellationToken);

        var inventoryByName = inventory
            .GroupBy(item => item.NormalizedName)
            .ToDictionary(group => group.Key, group => group.ToList());

        var today = DateOnly.FromDateTime(DateTime.UtcNow);
        var recipes = await provider.GetRecipesAsync(cancellationToken);

        return recipes
            .Select(recipe =>
            {
                var ingredientLines = recipe.Ingredients
                    .Select(ingredient => MapIngredientLine(ingredient, inventoryByName))
                    .ToList();

                var required = ingredientLines.Where(line => !line.Optional).ToList();
                var missing = required
                    .Where(line => line.Status != "sufficient")
                    .Select(line => line.Name)
                    .ToList();
                var owned = ingredientLines
                    .Where(line => line.Status == "sufficient")
                    .Select(line => line.Name)
                    .ToList();
                var expiringSoon = recipe.Ingredients.Count(ingredient =>
                    inventoryByName.TryGetValue(TextNormalizer.Ingredient(ingredient.Name), out var items)
                    && items.Any(item => item.ExpiryDate is not null && item.ExpiryDate <= today.AddDays(3)));

                var score = (owned.Count * 12m) - (missing.Count * 18m) + (expiringSoon * 8m) - Math.Min(recipe.EstimatedMinutes, 60) / 10m;
                var canCook = required.Count > 0 && required.All(line => line.Status == "sufficient");

                return new RecipeSuggestionResponse(
                    recipe.Id,
                    recipe.Name,
                    recipe.Description,
                    recipe.CuisineType,
                    recipe.Difficulty,
                    recipe.EstimatedMinutes,
                    recipe.Servings,
                    canCook,
                    ingredientLines,
                    owned.Count,
                    missing.Count,
                    expiringSoon,
                    score,
                    owned,
                    missing);
            })
            .OrderBy(suggestion => suggestion.MissingIngredientCount)
            .ThenByDescending(suggestion => suggestion.Score)
            .ThenBy(suggestion => suggestion.EstimatedMinutes)
            .ToList();
    }

    private static RecipeIngredientLineResponse MapIngredientLine(
        RecipeIngredientDto ingredient,
        IReadOnlyDictionary<string, List<InventoryItem>> inventoryByName)
    {
        var normalizedName = TextNormalizer.Ingredient(ingredient.Name);
        var inStockQuantity = 0m;

        if (inventoryByName.TryGetValue(normalizedName, out var matchingItems))
        {
            inStockQuantity = matchingItems
                .Where(item => item.Unit == ingredient.Unit)
                .Sum(item => item.Quantity);
        }

        var status = ingredient.Optional
            ? inStockQuantity > 0 ? "sufficient" : "missing"
            : inStockQuantity >= ingredient.Quantity
                ? "sufficient"
                : inStockQuantity > 0
                    ? "short"
                    : "missing";

        return new RecipeIngredientLineResponse(
            ingredient.Name,
            ingredient.Quantity,
            ingredient.Unit,
            ingredient.Optional,
            inStockQuantity,
            status);
    }
}
