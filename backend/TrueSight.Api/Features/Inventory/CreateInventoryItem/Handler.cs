using MediatR;
using Microsoft.EntityFrameworkCore;
using TrueSight.Api.Infrastructure;
using TrueSight.Api.Infrastructure.Data;
using TrueSight.Api.Shared;

namespace TrueSight.Api.Features.Inventory.CreateInventoryItem;

public sealed class Handler(TrueSightDbContext db, ICurrentUser currentUser)
    : IRequestHandler<CreateInventoryItemCommand, InventoryItemResponse>
{
    public async Task<InventoryItemResponse> Handle(CreateInventoryItemCommand request, CancellationToken cancellationToken)
    {
        var now = DateTimeOffset.UtcNow;
        var name = request.Name.Trim();
        var normalizedName = TextNormalizer.Ingredient(name);
        var unit = request.Unit.Trim().ToLowerInvariant();

        var existing = await db.InventoryItems.FirstOrDefaultAsync(
            item => item.UserId == currentUser.UserId
                && item.NormalizedName == normalizedName
                && item.Unit == unit,
            cancellationToken);

        if (existing is not null)
        {
            existing.Quantity += request.Quantity;
            existing.ExpiryDate = InventoryConsolidator.EarliestExpiry(existing.ExpiryDate, request.ExpiryDate);
            existing.Name = name;
            existing.UpdatedAt = now;
        }
        else
        {
            existing = new InventoryItem
            {
                Id = Guid.NewGuid(),
                UserId = currentUser.UserId,
                Name = name,
                NormalizedName = normalizedName,
                Quantity = request.Quantity,
                Unit = unit,
                ExpiryDate = request.ExpiryDate,
                AddedAt = now,
                UpdatedAt = now,
            };

            db.InventoryItems.Add(existing);
        }

        await InventoryConsolidator.ConsolidateAsync(db, currentUser.UserId, cancellationToken);
        await db.SaveChangesAsync(cancellationToken);

        return new InventoryItemResponse(
            existing.Id,
            existing.Name,
            existing.Quantity,
            existing.Unit,
            existing.ExpiryDate,
            existing.AddedAt,
            existing.UpdatedAt);
    }
}
