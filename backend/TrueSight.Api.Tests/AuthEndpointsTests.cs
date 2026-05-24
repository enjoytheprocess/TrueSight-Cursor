using System.Net;
using System.Net.Http.Json;
using TrueSight.Api.Features.Auth;
using TrueSight.Api.Tests.Support;

namespace TrueSight.Api.Tests;

public sealed class AuthEndpointsTests(TrueSightWebApplicationFactory factory) : IClassFixture<TrueSightWebApplicationFactory>
{
    [Fact]
    public async Task Register_login_and_me_round_trip()
    {
        var client = factory.CreateClient();
        var email = $"auth-{Guid.NewGuid():N}@example.com";
        const string password = "password123";

        var registerResponse = await client.PostAsJsonAsync("/api/auth/register", new RegisterRequest(email, password));
        Assert.Equal(HttpStatusCode.Created, registerResponse.StatusCode);

        var meAfterRegister = await client.GetFromJsonAsync<AuthUserResponse>("/api/auth/me");
        Assert.NotNull(meAfterRegister);
        Assert.Equal(email, meAfterRegister.Email);

        await client.PostAsync("/api/auth/logout", null);

        var loginResponse = await client.PostAsJsonAsync("/api/auth/login", new LoginRequest(email, password));
        Assert.Equal(HttpStatusCode.OK, loginResponse.StatusCode);

        var meAfterLogin = await client.GetFromJsonAsync<AuthUserResponse>("/api/auth/me");
        Assert.NotNull(meAfterLogin);
        Assert.Equal(email, meAfterLogin.Email);
    }

    [Fact]
    public async Task Inventory_is_isolated_between_authenticated_users()
    {
        var userA = factory.CreateClient();
        await userA.RegisterAndLoginAsync();

        var createResponse = await userA.PostJsonAsync("/api/inventory", new
        {
            name = "Milk",
            quantity = 1m,
            unit = "l",
            expiryDate = (string?)null,
        });

        Assert.Equal(HttpStatusCode.Created, createResponse.StatusCode);
        var created = await createResponse.ReadJsonAsync<InventoryItemDto>();
        Assert.NotNull(created);

        var userB = factory.CreateClient();
        await userB.RegisterAndLoginAsync();

        Assert.Equal(HttpStatusCode.NotFound, (await userB.GetAsync($"/api/inventory/{created.Id}")).StatusCode);
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
