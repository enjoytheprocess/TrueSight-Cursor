using MediatR;

namespace TrueSight.Api.Features.Inventory.ListInventoryItems;

public sealed record ListInventoryItemsQuery : IRequest<IReadOnlyList<InventoryItemResponse>>;

