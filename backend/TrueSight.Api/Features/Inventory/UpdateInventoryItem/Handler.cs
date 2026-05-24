using MediatR;
using Microsoft.EntityFrameworkCore;
using TrueSight.Api.Infrastructure;
using TrueSight.Api.Infrastructure.Data;
using TrueSight.Api.Shared;

namespace TrueSight.Api.Features.Inventory.UpdateInventoryItem;

public sealed class Handler(TrueSightDbContext db, ICurrentUser currentUser)
    : IRequestHandler<UpdateInventoryItemCommand, InventoryItemResponse?>
{
    public async Task<InventoryItemResponse?> Handle(UpdateInventoryItemCommand request, CancellationToken cancellationToken)
    {
        var item = await db.InventoryItems
            .SingleOrDefaultAsync(item => item.UserId == currentUser.UserId && item.Id == request.Id, cancellationToken);

        if (item is null)
        {
            return null;
        }

        item.Name = request.Name.Trim();
        item.NormalizedName = TextNormalizer.Ingredient(request.Name);
        item.Quantity = request.Quantity;
        item.Unit = request.Unit.Trim().ToLowerInvariant();
        item.ExpiryDate = request.ExpiryDate;
        item.UpdatedAt = DateTimeOffset.UtcNow;

        await db.SaveChangesAsync(cancellationToken);

        return new InventoryItemResponse(item.Id, item.Name, item.Quantity, item.Unit, item.ExpiryDate, item.AddedAt, item.UpdatedAt);
    }
}

