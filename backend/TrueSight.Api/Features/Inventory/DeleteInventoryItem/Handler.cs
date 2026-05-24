using MediatR;
using Microsoft.EntityFrameworkCore;
using TrueSight.Api.Infrastructure;
using TrueSight.Api.Infrastructure.Data;

namespace TrueSight.Api.Features.Inventory.DeleteInventoryItem;

public sealed class Handler(TrueSightDbContext db, ICurrentUser currentUser) : IRequestHandler<DeleteInventoryItemCommand, bool>
{
    public async Task<bool> Handle(DeleteInventoryItemCommand request, CancellationToken cancellationToken)
    {
        var item = await db.InventoryItems
            .SingleOrDefaultAsync(item => item.UserId == currentUser.UserId && item.Id == request.Id, cancellationToken);

        if (item is null)
        {
            return false;
        }

        db.InventoryItems.Remove(item);
        await db.SaveChangesAsync(cancellationToken);
        return true;
    }
}

