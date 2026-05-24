using MediatR;

namespace TrueSight.Api.Features.Inventory.DeleteInventoryItem;

public sealed record DeleteInventoryItemCommand(Guid Id) : IRequest<bool>;

