using Microsoft.EntityFrameworkCore;
using TrueSight.Api.Shared;

namespace TrueSight.Api.Infrastructure.Data;

public static class DemoInventorySeeder
{
    public const string DemoUserId = "demo-user";

    public static async Task SeedIfEmptyAsync(TrueSightDbContext db, CancellationToken cancellationToken = default)
    {
        var hasDemoInventory = await db.InventoryItems
            .AnyAsync(item => item.UserId == DemoUserId, cancellationToken);

        if (hasDemoInventory)
        {
            return;
        }

        var now = DateTimeOffset.UtcNow;
        var expiringSoon = DateOnly.FromDateTime(DateTime.UtcNow.AddDays(2));

        foreach (var seed in DemoItems(expiringSoon, now))
        {
            db.InventoryItems.Add(seed);
        }

        await db.SaveChangesAsync(cancellationToken);
        await InventoryConsolidator.ConsolidateAsync(db, DemoUserId, cancellationToken);
        await db.SaveChangesAsync(cancellationToken);
    }

    private static IEnumerable<InventoryItem> DemoItems(DateOnly expiringSoon, DateTimeOffset now) =>
    [
        Item("eggs", 8, "count", expiringSoon, now),
        Item("chicken", 400, "g", null, now),
        Item("spinach", 200, "g", expiringSoon, now),
        Item("cheese", 120, "g", null, now),
        Item("tomato", 4, "count", null, now),
        Item("pasta", 400, "g", null, now),
        Item("yogurt", 250, "g", null, now),
        Item("berries", 120, "g", expiringSoon, now),
        Item("oats", 60, "g", null, now),
    ];

    private static InventoryItem Item(string name, decimal quantity, string unit, DateOnly? expiryDate, DateTimeOffset now) =>
        new()
        {
            Id = Guid.NewGuid(),
            UserId = DemoUserId,
            Name = name,
            NormalizedName = TextNormalizer.Ingredient(name),
            Quantity = quantity,
            Unit = unit,
            ExpiryDate = expiryDate,
            AddedAt = now,
            UpdatedAt = now,
        };
}
