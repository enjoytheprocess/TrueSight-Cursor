using MediatR;

namespace TrueSight.Api.Features.Inventory.GetInventoryItem;

public sealed record GetInventoryItemQuery(Guid Id) : IRequest<InventoryItemResponse?>;

