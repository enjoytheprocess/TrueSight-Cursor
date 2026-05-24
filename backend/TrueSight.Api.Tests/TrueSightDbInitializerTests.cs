using Microsoft.Data.Sqlite;
using Microsoft.EntityFrameworkCore;
using TrueSight.Api.Infrastructure.Data;

namespace TrueSight.Api.Tests;

public sealed class TrueSightDbInitializerTests
{
    [Fact]
    public async Task InitializeAsync_creates_ShoppingListItems_on_legacy_inventory_only_database()
    {
        var connection = new SqliteConnection("Data Source=:memory:");
        await connection.OpenAsync();

        await using (var legacy = connection.CreateCommand())
        {
            legacy.CommandText = """
                CREATE TABLE "InventoryItems" (
                    "Id" TEXT NOT NULL CONSTRAINT "PK_InventoryItems" PRIMARY KEY,
                    "UserId" TEXT NOT NULL,
                    "Name" TEXT NOT NULL,
                    "NormalizedName" TEXT NOT NULL,
                    "Quantity" TEXT NOT NULL,
                    "Unit" TEXT NOT NULL,
                    "ExpiryDate" TEXT NULL,
                    "AddedAt" TEXT NOT NULL,
                    "UpdatedAt" TEXT NOT NULL
                );
                """;
            await legacy.ExecuteNonQueryAsync();
        }

        var options = new DbContextOptionsBuilder<TrueSightDbContext>()
            .UseSqlite(connection)
            .Options;

        await using var db = new TrueSightDbContext(options);
        await TrueSightDbInitializer.InitializeAsync(db);

        Assert.Equal(0, await db.ShoppingListItems.CountAsync());
    }
}
