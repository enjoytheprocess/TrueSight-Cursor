namespace TrueSight.Api.Features.ShoppingList;

public sealed record ShoppingListItemResponse(
    Guid Id,
    string Name,
    decimal Quantity,
    string Unit,
    string? SourceRecipeId,
    DateTimeOffset CreatedAt);

public sealed record CreateShoppingListItemRequest(
    string Name,
    decimal Quantity,
    string Unit,
    string? SourceRecipeId);

public sealed record MoveShoppingListItemToInventoryRequest(DateOnly? ExpiryDate);
