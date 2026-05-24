using MediatR;
using Microsoft.EntityFrameworkCore;
using TrueSight.Api.Infrastructure;
using TrueSight.Api.Infrastructure.Data;

namespace TrueSight.Api.Features.Inventory.GetInventoryItem;

public sealed class Handler(TrueSightDbContext db, ICurrentUser currentUser)
    : IRequestHandler<GetInventoryItemQuery, InventoryItemResponse?>
{
    public async Task<InventoryItemResponse?> Handle(GetInventoryItemQuery request, CancellationToken cancellationToken) =>
        await db.InventoryItems
            .AsNoTracking()
            .Where(item => item.UserId == currentUser.UserId && item.Id == request.Id)
            .Select(item => new InventoryItemResponse(
                item.Id,
                item.Name,
                item.Quantity,
                item.Unit,
                item.ExpiryDate,
                item.AddedAt,
                item.UpdatedAt))
            .SingleOrDefaultAsync(cancellationToken);
}

