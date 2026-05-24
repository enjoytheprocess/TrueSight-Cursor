using MediatR;
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
        var item = new InventoryItem
        {
            Id = Guid.NewGuid(),
            UserId = currentUser.UserId,
            Name = request.Name.Trim(),
            NormalizedName = TextNormalizer.Ingredient(request.Name),
            Quantity = request.Quantity,
            Unit = request.Unit.Trim().ToLowerInvariant(),
            ExpiryDate = request.ExpiryDate,
            AddedAt = now,
            UpdatedAt = now
        };

        db.InventoryItems.Add(item);
        await db.SaveChangesAsync(cancellationToken);

        return new InventoryItemResponse(item.Id, item.Name, item.Quantity, item.Unit, item.ExpiryDate, item.AddedAt, item.UpdatedAt);
    }
}

