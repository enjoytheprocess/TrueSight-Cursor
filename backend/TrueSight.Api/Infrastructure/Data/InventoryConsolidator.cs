using Microsoft.EntityFrameworkCore;
using TrueSight.Api.Shared;

namespace TrueSight.Api.Infrastructure.Data;

public static class InventoryConsolidator
{
    public static DateOnly? EarliestExpiry(DateOnly? existing, DateOnly? incoming)
    {
        if (existing is null)
        {
            return incoming;
        }

        if (incoming is null)
        {
            return existing;
        }

        return existing <= incoming ? existing : incoming;
    }

    public static async Task ConsolidateAsync(TrueSightDbContext db, string userId, CancellationToken cancellationToken)
    {
        var items = await db.InventoryItems
            .Where(item => item.UserId == userId)
            .ToListAsync(cancellationToken);

        var duplicateGroups = items
            .GroupBy(item => (item.NormalizedName, item.Unit))
            .Where(group => group.Count() > 1);

        var now = DateTimeOffset.UtcNow;

        foreach (var group in duplicateGroups)
        {
            var ordered = group
                .OrderBy(item => item.ExpiryDate == null)
                .ThenBy(item => item.ExpiryDate)
                .ThenBy(item => item.AddedAt)
                .ToList();

            var keeper = ordered[0];

            foreach (var duplicate in ordered.Skip(1))
            {
                keeper.Quantity += duplicate.Quantity;
                keeper.ExpiryDate = EarliestExpiry(keeper.ExpiryDate, duplicate.ExpiryDate);
                db.InventoryItems.Remove(duplicate);
            }

            keeper.UpdatedAt = now;
        }
    }
}
