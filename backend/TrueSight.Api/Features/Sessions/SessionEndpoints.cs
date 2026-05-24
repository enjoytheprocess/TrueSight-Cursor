using MediatR;
using Microsoft.AspNetCore.RateLimiting;
using TrueSight.Api.Features.Sessions.AcceptRecipe;
using TrueSight.Api.Features.Sessions.ListRecipeSessions;
using TrueSight.Api.Infrastructure.Security;

namespace TrueSight.Api.Features.Sessions;

public static class SessionEndpoints
{
    public static void MapSessionEndpoints(this IEndpointRouteBuilder routes)
    {
        var group = routes.MapGroup("/api/recipe-sessions").WithTags("Recipe sessions")
            .RequireRateLimiting(ApiMutationRateLimiting.PolicyName);

        group.MapGet("/", async (ISender sender, CancellationToken cancellationToken) =>
            Results.Ok(await sender.Send(new ListRecipeSessionsQuery(), cancellationToken)));

        group.MapPost("/", async (AcceptRecipeRequest request, ISender sender, CancellationToken cancellationToken) =>
        {
            var multiplier = request.ServingMultiplier is > 0 ? request.ServingMultiplier.Value : 1;
            var session = await sender.Send(new AcceptRecipeCommand(request.RecipeId, multiplier), cancellationToken);
            return Results.Created($"/api/recipe-sessions/{session.Id}", session);
        });
    }
}

