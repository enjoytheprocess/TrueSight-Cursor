using System.Net;
using System.Net.Http.Json;
using TrueSight.Api.Tests.Support;

namespace TrueSight.Api.Tests;

public sealed class ProductionSecurityTests(ProductionWebApplicationFactory factory) : IClassFixture<ProductionWebApplicationFactory>
{
    [Fact]
    public async Task Production_inventory_list_without_auth_returns_401()
    {
        var client = factory.CreateClient();

        var response = await client.GetAsync("/api/inventory");

        Assert.Equal(HttpStatusCode.Unauthorized, response.StatusCode);
    }

    [Fact]
    public async Task Production_inventory_list_after_register_returns_ok()
    {
        var client = factory.CreateClient();
        await client.RegisterAndLoginAsync();

        var response = await client.GetAsync("/api/inventory");

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
    }

    [Fact]
    public async Task Production_health_does_not_require_auth()
    {
        var client = factory.CreateClient();

        var response = await client.GetAsync("/api/health");

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
    }

    [Fact]
    public async Task Testing_environment_still_allows_header_identity()
    {
        using var testingFactory = new TrueSightWebApplicationFactory();
        var client = testingFactory.CreateClient().ForUser($"testing-user-{Guid.NewGuid():N}");

        var response = await client.GetAsync("/api/inventory");

        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
    }
}
