using MediatR;
using Microsoft.EntityFrameworkCore;
using TrueSight.Api.Infrastructure;
using TrueSight.Api.Infrastructure.Data;

namespace TrueSight.Api.Features.ShoppingList.ListShoppingListItems;

public sealed class Handler(TrueSightDbContext db, ICurrentUser currentUser)
    : IRequestHandler<ListShoppingListItemsQuery, IReadOnlyList<ShoppingListItemResponse>>
{
    public async Task<IReadOnlyList<ShoppingListItemResponse>> Handle(
        ListShoppingListItemsQuery request,
        CancellationToken cancellationToken)
    {
        var items = await db.ShoppingListItems
            .AsNoTracking()
            .Where(item => item.UserId == currentUser.UserId)
            .OrderBy(item => item.Name)
            .ToListAsync(cancellationToken);

        return items
            .OrderBy(item => item.Name)
            .ThenBy(item => item.CreatedAt)
            .Select(item => new ShoppingListItemResponse(
                item.Id,
                item.Name,
                item.Quantity,
                item.Unit,
                item.SourceRecipeId,
                item.CreatedAt))
            .ToList();
    }
}
