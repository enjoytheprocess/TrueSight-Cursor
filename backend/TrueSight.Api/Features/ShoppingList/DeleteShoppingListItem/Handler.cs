using MediatR;
using Microsoft.EntityFrameworkCore;
using TrueSight.Api.Infrastructure;
using TrueSight.Api.Infrastructure.Data;

namespace TrueSight.Api.Features.ShoppingList.DeleteShoppingListItem;

public sealed class Handler(TrueSightDbContext db, ICurrentUser currentUser)
    : IRequestHandler<DeleteShoppingListItemCommand, bool>
{
    public async Task<bool> Handle(DeleteShoppingListItemCommand request, CancellationToken cancellationToken)
    {
        var item = await db.ShoppingListItems
            .SingleOrDefaultAsync(
                item => item.UserId == currentUser.UserId && item.Id == request.Id,
                cancellationToken);

        if (item is null)
        {
            return false;
        }

        db.ShoppingListItems.Remove(item);
        await db.SaveChangesAsync(cancellationToken);
        return true;
    }
}
