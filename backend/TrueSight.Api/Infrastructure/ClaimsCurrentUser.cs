using System.Security.Claims;
using TrueSight.Api.Infrastructure.Security;

namespace TrueSight.Api.Infrastructure;

public sealed class ClaimsCurrentUser(
    IHttpContextAccessor accessor,
    IWebHostEnvironment environment,
    IConfiguration configuration) : ICurrentUser
{
    public string UserId
    {
        get
        {
            var httpContext = accessor.HttpContext
                ?? throw new InvalidOperationException("No HTTP context is available.");

            if (httpContext.User.Identity?.IsAuthenticated == true)
            {
                var userId = httpContext.User.FindFirstValue(ClaimTypes.NameIdentifier);
                if (!string.IsNullOrWhiteSpace(userId))
                {
                    return userId;
                }
            }

            if (AllowsHeaderIdentity())
            {
                var header = httpContext.Request.Headers["X-TrueSight-User"].FirstOrDefault();
                if (!string.IsNullOrWhiteSpace(header))
                {
                    var trimmed = header.Trim();
                    if (trimmed.Length > ProductionIdentityMiddleware.MaxUserIdLength)
                    {
                        throw new InvalidOperationException("X-TrueSight-User exceeds maximum length of 120.");
                    }

                    return trimmed;
                }

                if (configuration.GetValue("Auth:AllowDemoUser", false))
                {
                    return "demo-user";
                }
            }

            throw new UnauthorizedAccessException("Authentication is required.");
        }
    }

    private bool AllowsHeaderIdentity() =>
        environment.IsDevelopment()
        || environment.IsEnvironment("Testing")
        || configuration.GetValue("Auth:AllowHeaderIdentity", false);
}
