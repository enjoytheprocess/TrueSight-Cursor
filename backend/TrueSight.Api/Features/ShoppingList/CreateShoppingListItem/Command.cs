using MediatR;

namespace TrueSight.Api.Features.ShoppingList.CreateShoppingListItem;

public sealed record CreateShoppingListItemCommand(
    string Name,
    decimal Quantity,
    string Unit,
    string? SourceRecipeId) : IRequest<ShoppingListItemResponse>;
