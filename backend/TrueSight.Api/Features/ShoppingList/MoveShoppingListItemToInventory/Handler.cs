using MediatR;
using Microsoft.EntityFrameworkCore;
using TrueSight.Api.Features.Inventory;
using TrueSight.Api.Infrastructure;
using TrueSight.Api.Infrastructure.Data;

namespace TrueSight.Api.Features.ShoppingList.MoveShoppingListItemToInventory;

public sealed class Handler(TrueSightDbContext db, ICurrentUser currentUser)
    : IRequestHandler<MoveShoppingListItemToInventoryCommand, InventoryItemResponse?>
{
    public async Task<InventoryItemResponse?> Handle(
        MoveShoppingListItemToInventoryCommand request,
        CancellationToken cancellationToken)
    {
        var shoppingItem = await db.ShoppingListItems
            .SingleOrDefaultAsync(
                item => item.UserId == currentUser.UserId && item.Id == request.Id,
                cancellationToken);

        if (shoppingItem is null)
        {
            return null;
        }

        var now = DateTimeOffset.UtcNow;
        var existing = await db.InventoryItems.FirstOrDefaultAsync(
            item => item.UserId == currentUser.UserId
                && item.NormalizedName == shoppingItem.NormalizedName
                && item.Unit == shoppingItem.Unit,
            cancellationToken);

        if (existing is not null)
        {
            existing.Quantity += shoppingItem.Quantity;
            existing.ExpiryDate = InventoryConsolidator.EarliestExpiry(existing.ExpiryDate, request.ExpiryDate);
            existing.Name = shoppingItem.Name;
            existing.UpdatedAt = now;
        }
        else
        {
            existing = new InventoryItem
            {
                Id = Guid.NewGuid(),
                UserId = currentUser.UserId,
                Name = shoppingItem.Name,
                NormalizedName = shoppingItem.NormalizedName,
                Quantity = shoppingItem.Quantity,
                Unit = shoppingItem.Unit,
                ExpiryDate = request.ExpiryDate,
                AddedAt = now,
                UpdatedAt = now,
            };

            db.InventoryItems.Add(existing);
        }

        db.ShoppingListItems.Remove(shoppingItem);
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
