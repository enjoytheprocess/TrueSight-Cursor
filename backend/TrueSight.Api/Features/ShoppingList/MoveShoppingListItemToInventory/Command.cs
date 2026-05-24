using MediatR;
using TrueSight.Api.Features.Inventory;

namespace TrueSight.Api.Features.ShoppingList.MoveShoppingListItemToInventory;

public sealed record MoveShoppingListItemToInventoryCommand(Guid Id, DateOnly? ExpiryDate)
    : IRequest<InventoryItemResponse?>;
