using MediatR;

namespace TrueSight.Api.Features.Inventory.CreateInventoryItem;

public sealed record CreateInventoryItemCommand(string Name, decimal Quantity, string Unit, DateOnly? ExpiryDate)
    : IRequest<InventoryItemResponse>;

