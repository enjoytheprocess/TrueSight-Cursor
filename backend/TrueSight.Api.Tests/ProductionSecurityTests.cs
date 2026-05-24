using System.Net;
using TrueSight.Api.Infrastructure.Security;
using TrueSight.Api.Tests.Support;

namespace TrueSight.Api.Tests;

public sealed class ProductionSecurityTests(ProductionWebApplicationFactory factory) : IClassFixture<ProductionWebApplicationFactory>
{
    [Fact]
    public async Task Production_inventory_list_without_user_header_returns_401()
    {
        var client = factory.CreateClient();

        var response = await client.GetAsync("/api/inventory");

        Assert.Equal(HttpStatusCode.Unauthorized, response.StatusCode);
    }

    [Fact]
    public async Task Production_inventory_list_with_valid_user_header_succeeds()
    {
        var client = factory.CreateClient().ForUser($"production-user-{Guid.NewGuid():N}");

        var response = await client.GetAsync("/api/inventory");

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
    }

    [Fact]
    public async Task Production_rejects_oversized_user_header()
    {
        var client = factory.CreateClient();
        client.DefaultRequestHeaders.Add("X-TrueSight-User", new string('x', ProductionIdentityMiddleware.MaxUserIdLength + 1));

        var response = await client.GetAsync("/api/inventory");

        Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
    }

    [Fact]
    public async Task Production_health_does_not_require_user_header()
    {
        var client = factory.CreateClient();

        var response = await client.GetAsync("/api/health");

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
    }

    [Fact]
    public async Task Testing_environment_still_allows_missing_user_header()
    {
        using var testingFactory = new TrueSightWebApplicationFactory();
        var client = testingFactory.CreateClient();

        var response = await client.GetAsync("/api/inventory");

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
    }
}
