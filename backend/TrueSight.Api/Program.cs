using System.Reflection;
using FluentValidation;
using MediatR;
using Microsoft.EntityFrameworkCore;
using TrueSight.Api.Features.Inventory;
using TrueSight.Api.Features.Recipes;
using TrueSight.Api.Features.Sessions;
using TrueSight.Api.Infrastructure;
using TrueSight.Api.Infrastructure.Data;
using TrueSight.Api.Infrastructure.Recipes;
using TrueSight.Api.Shared;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddDbContext<TrueSightDbContext>(options =>
    options.UseSqlite(builder.Configuration.GetConnectionString("TrueSight")
        ?? "Data Source=truesight.db"));

builder.Services.AddHttpContextAccessor();
builder.Services.AddScoped<ICurrentUser, HeaderCurrentUser>();
builder.Services.AddScoped<IRecipeProvider, StaticRecipeProvider>();
builder.Services.AddMediatR(configuration =>
{
    configuration.RegisterServicesFromAssembly(Assembly.GetExecutingAssembly());
    configuration.AddOpenBehavior(typeof(ValidationBehavior<,>));
});
builder.Services.AddValidatorsFromAssembly(Assembly.GetExecutingAssembly());
builder.Services.AddProblemDetails();
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
        policy.AllowAnyHeader().AllowAnyMethod().AllowAnyOrigin());
});

var app = builder.Build();

app.UseExceptionHandler();
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
    catch (InvalidOperationException ex)
    {
        await Results.Problem(ex.Message, statusCode: StatusCodes.Status400BadRequest).ExecuteAsync(context);
    }
});
app.UseCors();

using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<TrueSightDbContext>();
    await db.Database.EnsureCreatedAsync();
}

app.MapGet("/api/health", () => Results.Ok(new { status = "ok" }));
app.MapInventoryEndpoints();
app.MapRecipeEndpoints();
app.MapSessionEndpoints();

app.Run();

public partial class Program;
