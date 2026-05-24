using MediatR;
using Microsoft.EntityFrameworkCore;
using TrueSight.Api.Infrastructure;
using TrueSight.Api.Infrastructure.Data;

namespace TrueSight.Api.Features.Inventory.ListInventoryItems;

public sealed class Handler(TrueSightDbContext db, ICurrentUser currentUser)
    : IRequestHandler<ListInventoryItemsQuery, IReadOnlyList<InventoryItemResponse>>
{
    public async Task<IReadOnlyList<InventoryItemResponse>> Handle(ListInventoryItemsQuery request, CancellationToken cancellationToken) =>
        await db.InventoryItems
            .AsNoTracking()
            .Where(item => item.UserId == currentUser.UserId)
            .OrderBy(item => item.ExpiryDate == null)
            .ThenBy(item => item.ExpiryDate)
            .ThenBy(item => item.Name)
            .Select(item => new InventoryItemResponse(
                item.Id,
                item.Name,
                item.Quantity,
                item.Unit,
                item.ExpiryDate,
                item.AddedAt,
                item.UpdatedAt))
            .ToListAsync(cancellationToken);
}

