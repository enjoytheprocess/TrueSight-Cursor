using MediatR;
using Microsoft.EntityFrameworkCore;
using TrueSight.Api.Features.Recipes;
using TrueSight.Api.Infrastructure;
using TrueSight.Api.Infrastructure.Data;
using TrueSight.Api.Infrastructure.Recipes;
using TrueSight.Api.Shared;

namespace TrueSight.Api.Features.Sessions.AcceptRecipe;

public sealed class Handler(TrueSightDbContext db, ICurrentUser currentUser, IRecipeProvider provider)
    : IRequestHandler<AcceptRecipeCommand, RecipeSessionResponse>
{
    public async Task<RecipeSessionResponse> Handle(AcceptRecipeCommand request, CancellationToken cancellationToken)
    {
        var recipe = await provider.GetRecipeAsync(request.RecipeId, cancellationToken)
            ?? throw new InvalidOperationException("Recipe was not found.");

        var inventory = await db.InventoryItems
            .Where(item => item.UserId == currentUser.UserId && item.Quantity > 0)
            .ToListAsync(cancellationToken);

        var inventoryByName = inventory
            .GroupBy(item => item.NormalizedName)
            .ToDictionary(group => group.Key, group => group.OrderBy(item => item.ExpiryDate == null).ThenBy(item => item.ExpiryDate).ToList());

        var deductions = new List<(InventoryItem Item, string IngredientName, decimal Quantity, string Unit)>();
        var insufficient = new List<string>();

        foreach (var ingredient in recipe.Ingredients)
        {
            PlanDeduction(
                ingredient,
                request.ServingMultiplier,
                inventoryByName,
                deductions,
                insufficient);
        }

        if (insufficient.Count > 0)
        {
            throw new InvalidOperationException($"Insufficient inventory. {string.Join("; ", insufficient)}.");
        }

        var now = DateTimeOffset.UtcNow;
        var session = new RecipeSession
        {
            Id = Guid.NewGuid(),
            UserId = currentUser.UserId,
            RecipeId = recipe.Id,
            RecipeName = recipe.Name,
            ServingMultiplier = request.ServingMultiplier,
            AcceptedAt = now
        };

        foreach (var deduction in deductions)
        {
            deduction.Item.Quantity -= deduction.Quantity;
            deduction.Item.UpdatedAt = now;
            session.Lines.Add(new RecipeSessionLine
            {
                Id = Guid.NewGuid(),
                InventoryItemId = deduction.Item.Id,
                IngredientName = deduction.IngredientName,
                QuantityDeducted = deduction.Quantity,
                Unit = deduction.Unit
            });
        }

        db.RecipeSessions.Add(session);
        await db.SaveChangesAsync(cancellationToken);

        return new RecipeSessionResponse(
            session.Id,
            session.RecipeId,
            session.RecipeName,
            session.ServingMultiplier,
            session.AcceptedAt,
            session.Lines.Select(line => new RecipeSessionLineResponse(line.IngredientName, line.QuantityDeducted, line.Unit)).ToList());
    }

    private static void PlanDeduction(
        RecipeIngredientDto ingredient,
        int servingMultiplier,
        IReadOnlyDictionary<string, List<InventoryItem>> inventoryByName,
        List<(InventoryItem Item, string IngredientName, decimal Quantity, string Unit)> deductions,
        List<string> insufficient)
    {
        var normalizedName = TextNormalizer.Ingredient(ingredient.Name);
        var requiredQuantity = ingredient.Quantity * servingMultiplier;

        if (!inventoryByName.TryGetValue(normalizedName, out var matchingItems))
        {
            insufficient.Add($"{ingredient.Name}: need {requiredQuantity:0.##} {ingredient.Unit}, have 0");
            return;
        }

        var sameUnitItems = matchingItems.Where(item => item.Unit == ingredient.Unit).ToList();
        var availableQuantity = sameUnitItems.Sum(item => item.Quantity);

        if (availableQuantity < requiredQuantity)
        {
            insufficient.Add($"{ingredient.Name}: need {requiredQuantity:0.##} {ingredient.Unit}, have {availableQuantity:0.##}");
            return;
        }

        ApplyDeductions(sameUnitItems, requiredQuantity, ingredient.Name, ingredient.Unit, deductions);
    }

    private static void ApplyDeductions(
        IReadOnlyList<InventoryItem> sameUnitItems,
        decimal quantityToDeduct,
        string ingredientName,
        string unit,
        List<(InventoryItem Item, string IngredientName, decimal Quantity, string Unit)> deductions)
    {
        var remaining = quantityToDeduct;

        foreach (var item in sameUnitItems)
        {
            if (remaining <= 0)
            {
                break;
            }

            var quantity = Math.Min(item.Quantity, remaining);
            deductions.Add((item, ingredientName, quantity, unit));
            remaining -= quantity;
        }
    }
}
