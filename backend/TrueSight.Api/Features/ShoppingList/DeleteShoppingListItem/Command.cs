using MediatR;

namespace TrueSight.Api.Features.ShoppingList.DeleteShoppingListItem;

public sealed record DeleteShoppingListItemCommand(Guid Id) : IRequest<bool>;
