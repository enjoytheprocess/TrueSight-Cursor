namespace TrueSight.Api.Infrastructure.Security;

public sealed class ProductionIdentityMiddleware(RequestDelegate next, IWebHostEnvironment environment)
{
    public const int MaxUserIdLength = 120;

    public async Task InvokeAsync(HttpContext context)
    {
        if (!environment.IsProduction())
        {
            await next(context);
            return;
        }

        if (!context.Request.Path.StartsWithSegments("/api"))
        {
            await next(context);
            return;
        }

        if (context.Request.Path.StartsWithSegments("/api/health")
            && HttpMethods.IsGet(context.Request.Method))
        {
            await next(context);
            return;
        }

        var header = context.Request.Headers["X-TrueSight-User"].FirstOrDefault();
        if (string.IsNullOrWhiteSpace(header))
        {
            context.Response.StatusCode = StatusCodes.Status401Unauthorized;
            return;
        }

        if (header.Trim().Length > MaxUserIdLength)
        {
            context.Response.StatusCode = StatusCodes.Status400BadRequest;
            await context.Response.WriteAsync("X-TrueSight-User exceeds maximum length of 120.");
            return;
        }

        await next(context);
    }
}
