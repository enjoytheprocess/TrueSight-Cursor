using MediatR;
using TrueSight.Api.Features.Recipes.GetRecipe;
using TrueSight.Api.Features.Recipes.ListRecipeSuggestions;

namespace TrueSight.Api.Features.Recipes;

public static class RecipeEndpoints
{
    public static void MapRecipeEndpoints(this IEndpointRouteBuilder routes)
    {
        var group = routes.MapGroup("/api/recipes").WithTags("Recipes");

        group.MapGet("/suggestions", async (ISender sender, CancellationToken cancellationToken) =>
            Results.Ok(await sender.Send(new ListRecipeSuggestionsQuery(), cancellationToken)));

        group.MapGet("/{id}", async (string id, ISender sender, CancellationToken cancellationToken) =>
            await sender.Send(new GetRecipeQuery(id), cancellationToken) is { } recipe
                ? Results.Ok(recipe)
                : Results.NotFound());
    }
}

