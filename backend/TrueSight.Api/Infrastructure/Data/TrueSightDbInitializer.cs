using Microsoft.EntityFrameworkCore;

namespace TrueSight.Api.Infrastructure.Data;

/// <summary>
/// Ensures the SQLite schema matches the current model. <see cref="DatabaseFacade.EnsureCreatedAsync"/>
/// does not alter existing databases when new tables are added.
/// </summary>
public static class TrueSightDbInitializer
{
    public static async Task InitializeAsync(TrueSightDbContext db, CancellationToken cancellationToken = default)
    {
        await db.Database.EnsureCreatedAsync(cancellationToken);
        await EnsureShoppingListTableAsync(db, cancellationToken);
        await DemoInventorySeeder.SeedIfEmptyAsync(db, cancellationToken);
    }

    private static async Task EnsureShoppingListTableAsync(TrueSightDbContext db, CancellationToken cancellationToken)
    {
        await db.Database.ExecuteSqlRawAsync(
            """
            CREATE TABLE IF NOT EXISTS "ShoppingListItems" (
                "Id" TEXT NOT NULL CONSTRAINT "PK_ShoppingListItems" PRIMARY KEY,
                "UserId" TEXT NOT NULL,
                "Name" TEXT NOT NULL,
                "NormalizedName" TEXT NOT NULL,
                "Quantity" TEXT NOT NULL,
                "Unit" TEXT NOT NULL,
                "SourceRecipeId" TEXT NULL,
                "CreatedAt" TEXT NOT NULL
            );
            """,
            cancellationToken);

        await db.Database.ExecuteSqlRawAsync(
            """
            CREATE INDEX IF NOT EXISTS "IX_ShoppingListItems_UserId_NormalizedName_Unit"
            ON "ShoppingListItems" ("UserId", "NormalizedName", "Unit");
            """,
            cancellationToken);
    }
}
