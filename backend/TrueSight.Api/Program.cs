using System.Reflection;
using FluentValidation;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.RateLimiting;
using Microsoft.EntityFrameworkCore;
using TrueSight.Api.Features.Auth;
using TrueSight.Api.Features.Inventory;
using TrueSight.Api.Features.Recipes;
using TrueSight.Api.Features.Sessions;
using TrueSight.Api.Features.ShoppingList;
using TrueSight.Api.Infrastructure;
using TrueSight.Api.Infrastructure.Data;
using TrueSight.Api.Infrastructure.Recipes;
using TrueSight.Api.Infrastructure.Security;
using TrueSight.Api.Shared;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddDbContext<TrueSightDbContext>(options =>
    options.UseSqlite(builder.Configuration.GetConnectionString("TrueSight")
        ?? "Data Source=truesight.db"));

builder.Services.AddIdentityCore<ApplicationUser>(options =>
    {
        options.User.RequireUniqueEmail = true;
        options.Password.RequiredLength = 8;
        options.Password.RequireNonAlphanumeric = false;
        options.Password.RequireUppercase = false;
        options.Password.RequireLowercase = false;
        options.Password.RequireDigit = false;
    })
    .AddEntityFrameworkStores<TrueSightDbContext>()
    .AddSignInManager()
    .AddDefaultTokenProviders();

builder.Services.AddAuthentication(options =>
    {
        options.DefaultScheme = IdentityConstants.ApplicationScheme;
        options.DefaultSignInScheme = IdentityConstants.ApplicationScheme;
    })
    .AddIdentityCookies();

builder.Services.ConfigureApplicationCookie(options =>
{
    options.Events.OnRedirectToLogin = context =>
    {
        context.Response.StatusCode = StatusCodes.Status401Unauthorized;
        return Task.CompletedTask;
    };
    options.Events.OnRedirectToAccessDenied = context =>
    {
        context.Response.StatusCode = StatusCodes.Status403Forbidden;
        return Task.CompletedTask;
    };
});

if (builder.Environment.IsProduction())
{
    builder.Services.AddAuthorization(options =>
    {
        options.FallbackPolicy = new AuthorizationPolicyBuilder()
            .RequireAuthenticatedUser()
            .Build();
    });
}
else
{
    builder.Services.AddAuthorization();
}

builder.Services.AddHttpContextAccessor();
builder.Services.AddScoped<ICurrentUser, ClaimsCurrentUser>();
builder.Services.AddScoped<IRecipeProvider, StaticRecipeProvider>();
builder.Services.AddMediatR(configuration =>
{
    configuration.RegisterServicesFromAssembly(Assembly.GetExecutingAssembly());
    configuration.AddOpenBehavior(typeof(ValidationBehavior<,>));
});
builder.Services.AddValidatorsFromAssembly(Assembly.GetExecutingAssembly());
builder.Services.AddProblemDetails();
builder.Services.AddTrueSightCors(builder.Environment, builder.Configuration);
builder.Services.AddApiMutationRateLimiting(builder.Configuration);

var app = builder.Build();

app.UseExceptionHandler();
app.UseMiddleware<SecurityHeadersMiddleware>();
app.Use(async (context, next) =>
{
    try
    {
        await next(context);
    }
    catch (ValidationException ex)
    {
        var errors = ex.Errors
            .GroupBy(error => error.PropertyName)
            .ToDictionary(group => group.Key, group => group.Select(error => error.ErrorMessage).ToArray());

        await Results.ValidationProblem(errors).ExecuteAsync(context);
    }
    catch (UnauthorizedAccessException ex)
    {
        await Results.Problem(ex.Message, statusCode: StatusCodes.Status401Unauthorized).ExecuteAsync(context);
    }
    catch (InvalidOperationException ex)
    {
        await Results.Problem(ex.Message, statusCode: StatusCodes.Status400BadRequest).ExecuteAsync(context);
    }
});

if (app.Environment.IsProduction())
{
    app.UseHsts();
    app.UseHttpsRedirection();
}

app.UseCors();
app.UseAuthentication();
app.UseAuthorization();
app.UseRateLimiter();

using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<TrueSightDbContext>();
    await TrueSightDbInitializer.InitializeAsync(db);
}

app.MapGet("/api/health", () => Results.Ok(new { status = "ok" })).AllowAnonymous();
app.MapAuthEndpoints();
app.MapInventoryEndpoints();
app.MapShoppingListEndpoints();
app.MapRecipeEndpoints();
app.MapSessionEndpoints();

app.Run();

public partial class Program;
