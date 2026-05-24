using MediatR;

namespace TrueSight.Api.Features.Inventory.UpdateInventoryItem;

public sealed record UpdateInventoryItemCommand(Guid Id, string Name, decimal Quantity, string Unit, DateOnly? ExpiryDate)
    : IRequest<InventoryItemResponse?>;

