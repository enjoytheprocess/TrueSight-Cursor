using System.Net;
using TrueSight.Api.Infrastructure.Data;
using TrueSight.Api.Tests.Support;

namespace TrueSight.Api.Tests;

public sealed class DemoInventorySeederTests(TrueSightWebApplicationFactory factory) : IClassFixture<TrueSightWebApplicationFactory>
{
    [Fact]
    public async Task Demo_user_starts_with_seeded_inventory()
    {
        var client = factory.CreateClient().ForUser(DemoInventorySeeder.DemoUserId);

        var response = await client.GetAsync("/api/inventory");
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);

        var items = await response.ReadJsonAsync<List<InventoryItemDto>>();
        Assert.NotNull(items);
        Assert.NotEmpty(items);
        Assert.Contains(items, item => item.Name == "eggs");
        Assert.Contains(items, item => item.Quantity > 0);
    }

    private sealed record InventoryItemDto(
        Guid Id,
        string Name,
        decimal Quantity,
        string Unit,
        DateOnly? ExpiryDate,
        DateTimeOffset AddedAt,
        DateTimeOffset UpdatedAt);
}
