using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace TrueSight.Api.Infrastructure.Data;

public sealed class TrueSightDbContext(DbContextOptions<TrueSightDbContext> options)
    : IdentityDbContext<ApplicationUser>(options)
{
    public DbSet<InventoryItem> InventoryItems => Set<InventoryItem>();

    public DbSet<ShoppingListItem> ShoppingListItems => Set<ShoppingListItem>();

    public DbSet<RecipeSession> RecipeSessions => Set<RecipeSession>();

    public DbSet<RecipeSessionLine> RecipeSessionLines => Set<RecipeSessionLine>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<InventoryItem>(entity =>
        {
            entity.HasKey(item => item.Id);
            entity.Property(item => item.Name).HasMaxLength(120).IsRequired();
            entity.Property(item => item.Unit).HasMaxLength(32).IsRequired();
            entity.Property(item => item.UserId).HasMaxLength(120).IsRequired();
            entity.HasIndex(item => new { item.UserId, item.NormalizedName });
        });

        modelBuilder.Entity<ShoppingListItem>(entity =>
        {
            entity.HasKey(item => item.Id);
            entity.Property(item => item.Name).HasMaxLength(120).IsRequired();
            entity.Property(item => item.Unit).HasMaxLength(32).IsRequired();
            entity.Property(item => item.UserId).HasMaxLength(120).IsRequired();
            entity.Property(item => item.SourceRecipeId).HasMaxLength(80);
            entity.HasIndex(item => new { item.UserId, item.NormalizedName, item.Unit });
        });

        modelBuilder.Entity<RecipeSession>(entity =>
        {
            entity.HasKey(session => session.Id);
            entity.Property(session => session.RecipeId).HasMaxLength(80).IsRequired();
            entity.Property(session => session.RecipeName).HasMaxLength(160).IsRequired();
            entity.Property(session => session.UserId).HasMaxLength(120).IsRequired();
            entity.HasMany(session => session.Lines)
                .WithOne(line => line.Session)
                .HasForeignKey(line => line.SessionId)
                .OnDelete(DeleteBehavior.Cascade);
        });

        modelBuilder.Entity<RecipeSessionLine>(entity =>
        {
            entity.HasKey(line => line.Id);
            entity.Property(line => line.IngredientName).HasMaxLength(120).IsRequired();
            entity.Property(line => line.Unit).HasMaxLength(32).IsRequired();
        });
    }
}

public sealed class InventoryItem
{
    public Guid Id { get; set; }
    public string UserId { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
    public string NormalizedName { get; set; } = string.Empty;
    public decimal Quantity { get; set; }
    public string Unit { get; set; } = string.Empty;
    public DateOnly? ExpiryDate { get; set; }
    public DateTimeOffset AddedAt { get; set; }
    public DateTimeOffset UpdatedAt { get; set; }
}

public sealed class ShoppingListItem
{
    public Guid Id { get; set; }
    public string UserId { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
    public string NormalizedName { get; set; } = string.Empty;
    public decimal Quantity { get; set; }
    public string Unit { get; set; } = string.Empty;
    public string? SourceRecipeId { get; set; }
    public DateTimeOffset CreatedAt { get; set; }
}

public sealed class RecipeSession
{
    public Guid Id { get; set; }
    public string UserId { get; set; } = string.Empty;
    public string RecipeId { get; set; } = string.Empty;
    public string RecipeName { get; set; } = string.Empty;
    public decimal ServingMultiplier { get; set; }
    public DateTimeOffset AcceptedAt { get; set; }
    public List<RecipeSessionLine> Lines { get; set; } = [];
}

public sealed class RecipeSessionLine
{
    public Guid Id { get; set; }
    public Guid SessionId { get; set; }
    public RecipeSession Session { get; set; } = null!;
    public Guid? InventoryItemId { get; set; }
    public string IngredientName { get; set; } = string.Empty;
    public decimal QuantityDeducted { get; set; }
    public string Unit { get; set; } = string.Empty;
}

