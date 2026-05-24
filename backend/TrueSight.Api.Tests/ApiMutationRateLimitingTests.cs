using Microsoft.AspNetCore.Http;
using TrueSight.Api.Infrastructure.Security;

namespace TrueSight.Api.Tests;

public sealed class ApiMutationRateLimitingTests
{
    [Theory]
    [InlineData("POST", "/api/inventory", true)]
    [InlineData("PUT", "/api/inventory/00000000-0000-0000-0000-000000000001", true)]
    [InlineData("DELETE", "/api/shopping-list/00000000-0000-0000-0000-000000000001", true)]
    [InlineData("GET", "/api/inventory", false)]
    [InlineData("POST", "/api/health", false)]
    public void IsApiMutation_matches_expected_routes(string method, string path, bool expected)
    {
        var context = new DefaultHttpContext
        {
            Request =
            {
                Method = method,
                Path = path
            }
        };

        Assert.Equal(expected, ApiMutationRateLimiting.IsApiMutation(context));
    }
}
