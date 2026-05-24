namespace TrueSight.Api.Features.Recipes;

public sealed record RecipeIngredientDto(string Name, decimal Quantity, string Unit, bool Optional);

public sealed record RecipeIngredientLineResponse(
    string Name,
    decimal RequiredQuantity,
    string Unit,
    bool Optional,
    decimal InStockQuantity,
    string Status);

public sealed record RecipeDto(
    string Id,
    string Name,
    string Description,
    string CuisineType,
    string Difficulty,
    int EstimatedMinutes,
    int Servings,
    IReadOnlyList<RecipeIngredientDto> Ingredients,
    IReadOnlyList<string> Steps);

public sealed record RecipeSuggestionResponse(
    string Id,
    string Name,
    string Description,
    string CuisineType,
    string Difficulty,
    int EstimatedMinutes,
    int Servings,
    bool CanCook,
    IReadOnlyList<RecipeIngredientLineResponse> Ingredients,
    int OwnedIngredientCount,
    int MissingIngredientCount,
    int ExpiringSoonIngredientCount,
    decimal Score,
    IReadOnlyList<string> UsesIngredients,
    IReadOnlyList<string> MissingIngredients);

