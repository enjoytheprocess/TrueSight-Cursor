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
                var required = recipe.Ingredients.Where(ingredient => !ingredient.Optional).ToList();
                var owned = recipe.Ingredients
                    .Where(ingredient => inventoryByName.ContainsKey(TextNormalizer.Ingredient(ingredient.Name)))
                    .Select(ingredient => ingredient.Name)
                    .ToList();
                var missing = required
                    .Where(ingredient => !inventoryByName.ContainsKey(TextNormalizer.Ingredient(ingredient.Name)))
                    .Select(ingredient => ingredient.Name)
                    .ToList();
                var expiringSoon = recipe.Ingredients.Count(ingredient =>
                    inventoryByName.TryGetValue(TextNormalizer.Ingredient(ingredient.Name), out var items)
                    && items.Any(item => item.ExpiryDate is not null && item.ExpiryDate <= today.AddDays(3)));

                var score = (owned.Count * 12m) - (missing.Count * 18m) + (expiringSoon * 8m) - Math.Min(recipe.EstimatedMinutes, 60) / 10m;

                return new RecipeSuggestionResponse(
                    recipe.Id,
                    recipe.Name,
                    recipe.Description,
                    recipe.CuisineType,
                    recipe.Difficulty,
                    recipe.EstimatedMinutes,
                    recipe.Servings,
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
}

