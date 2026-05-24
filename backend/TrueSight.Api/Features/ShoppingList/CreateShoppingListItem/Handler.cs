using MediatR;
using Microsoft.EntityFrameworkCore;
using TrueSight.Api.Infrastructure;
using TrueSight.Api.Infrastructure.Data;
using TrueSight.Api.Shared;

namespace TrueSight.Api.Features.ShoppingList.CreateShoppingListItem;

public sealed class Handler(TrueSightDbContext db, ICurrentUser currentUser)
    : IRequestHandler<CreateShoppingListItemCommand, ShoppingListItemResponse>
{
    public async Task<ShoppingListItemResponse> Handle(
        CreateShoppingListItemCommand request,
        CancellationToken cancellationToken)
    {
        var now = DateTimeOffset.UtcNow;
        var name = request.Name.Trim();
        var normalizedName = TextNormalizer.Ingredient(name);
        var unit = request.Unit.Trim().ToLowerInvariant();

        var existing = await db.ShoppingListItems.FirstOrDefaultAsync(
            item => item.UserId == currentUser.UserId
                && item.NormalizedName == normalizedName
                && item.Unit == unit,
            cancellationToken);

        if (existing is not null)
        {
            existing.Quantity += request.Quantity;
            existing.Name = name;
            if (request.SourceRecipeId is not null)
            {
                existing.SourceRecipeId = request.SourceRecipeId;
            }
        }
        else
        {
            existing = new ShoppingListItem
            {
                Id = Guid.NewGuid(),
                UserId = currentUser.UserId,
                Name = name,
                NormalizedName = normalizedName,
                Quantity = request.Quantity,
                Unit = unit,
                SourceRecipeId = request.SourceRecipeId,
                CreatedAt = now,
            };

            db.ShoppingListItems.Add(existing);
        }

        await db.SaveChangesAsync(cancellationToken);

        return new ShoppingListItemResponse(
            existing.Id,
            existing.Name,
            existing.Quantity,
            existing.Unit,
            existing.SourceRecipeId,
            existing.CreatedAt);
    }
}
