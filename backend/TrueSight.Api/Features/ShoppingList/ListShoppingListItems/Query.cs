using MediatR;

namespace TrueSight.Api.Features.ShoppingList.ListShoppingListItems;

public sealed record ListShoppingListItemsQuery : IRequest<IReadOnlyList<ShoppingListItemResponse>>;
