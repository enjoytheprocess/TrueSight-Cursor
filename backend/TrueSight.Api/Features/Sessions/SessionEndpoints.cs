using MediatR;
using TrueSight.Api.Features.Sessions.AcceptRecipe;
using TrueSight.Api.Features.Sessions.ListRecipeSessions;

namespace TrueSight.Api.Features.Sessions;

public static class SessionEndpoints
{
    public static void MapSessionEndpoints(this IEndpointRouteBuilder routes)
    {
        var group = routes.MapGroup("/api/recipe-sessions").WithTags("Recipe sessions");

        group.MapGet("/", async (ISender sender, CancellationToken cancellationToken) =>
            Results.Ok(await sender.Send(new ListRecipeSessionsQuery(), cancellationToken)));

        group.MapPost("/", async (AcceptRecipeRequest request, ISender sender, CancellationToken cancellationToken) =>
        {
            var session = await sender.Send(new AcceptRecipeCommand(request.RecipeId, request.ServingMultiplier), cancellationToken);
            return Results.Created($"/api/recipe-sessions/{session.Id}", session);
        });
    }
}

