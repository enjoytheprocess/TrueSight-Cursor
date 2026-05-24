namespace TrueSight.Api.Features.Sessions;

public sealed record AcceptRecipeRequest(string RecipeId, int? ServingMultiplier);

public sealed record RecipeSessionLineResponse(string IngredientName, decimal QuantityDeducted, string Unit);

public sealed record RecipeSessionResponse(
    Guid Id,
    string RecipeId,
    string RecipeName,
    decimal ServingMultiplier,
    DateTimeOffset AcceptedAt,
    IReadOnlyList<RecipeSessionLineResponse> Lines);

