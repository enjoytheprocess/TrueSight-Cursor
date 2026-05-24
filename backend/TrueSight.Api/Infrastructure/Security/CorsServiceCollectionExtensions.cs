namespace TrueSight.Api.Infrastructure.Security;

public static class CorsServiceCollectionExtensions
{
    public static IServiceCollection AddTrueSightCors(this IServiceCollection services, IWebHostEnvironment environment, IConfiguration configuration)
    {
        services.AddCors(options =>
        {
            options.AddDefaultPolicy(policy =>
            {
                if (environment.IsDevelopment() || environment.IsEnvironment("Testing"))
                {
                    policy.AllowAnyHeader().AllowAnyMethod().AllowAnyOrigin();
                    return;
                }

                var origins = configuration.GetSection("Cors:AllowedOrigins").Get<string[]>() ?? [];
                if (origins.Length == 0)
                {
                    throw new InvalidOperationException(
                        "Cors:AllowedOrigins must contain at least one origin in Production.");
                }

                policy.WithOrigins(origins).AllowAnyHeader().AllowAnyMethod();
            });
        });

        return services;
    }
}
