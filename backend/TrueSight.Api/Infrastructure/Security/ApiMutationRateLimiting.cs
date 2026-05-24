using System.Threading.RateLimiting;
using Microsoft.AspNetCore.RateLimiting;

namespace TrueSight.Api.Infrastructure.Security;

public static class ApiMutationRateLimiting
{
    public const string PolicyName = "api-mutations";

    public static IServiceCollection AddApiMutationRateLimiting(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        var permitLimit = configuration.GetValue("RateLimiting:PermitLimit", 100);
        var windowSeconds = configuration.GetValue("RateLimiting:WindowSeconds", 60);

        services.AddRateLimiter(options =>
        {
            options.RejectionStatusCode = StatusCodes.Status429TooManyRequests;
            options.AddPolicy(PolicyName, httpContext =>
            {
                if (!IsApiMutation(httpContext))
                {
                    return RateLimitPartition.GetNoLimiter(string.Empty);
                }

                var partitionKey = httpContext.Connection.RemoteIpAddress?.ToString() ?? "unknown";
                return RateLimitPartition.GetFixedWindowLimiter(partitionKey, _ => new FixedWindowRateLimiterOptions
                {
                    PermitLimit = permitLimit,
                    Window = TimeSpan.FromSeconds(windowSeconds),
                    QueueLimit = 0,
                    AutoReplenishment = true
                });
            });
        });

        return services;
    }

    public static bool IsApiMutation(HttpContext context) =>
        context.Request.Path.StartsWithSegments("/api")
        && !context.Request.Path.StartsWithSegments("/api/health")
        && (HttpMethods.IsPost(context.Request.Method)
            || HttpMethods.IsPut(context.Request.Method)
            || HttpMethods.IsDelete(context.Request.Method));
}
