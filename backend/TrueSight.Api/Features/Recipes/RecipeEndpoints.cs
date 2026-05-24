using MediatR;
using TrueSight.Api.Features.Recipes.GetRecipe;
using TrueSight.Api.Features.Recipes.ListRecipeSuggestions;

namespace TrueSight.Api.Features.Recipes;

public static class RecipeEndpoints
{
    public static void MapRecipeEndpoints(this IEndpointRouteBuilder routes)
    {
        var group = routes.MapGroup("/api/recipes").WithTags("Recipes");

        group.MapGet("/suggestions", async (string? allergies, string? preferred, ISender sender, CancellationToken cancellationToken) =>
            Results.Ok(await sender.Send(new ListRecipeSuggestionsQuery(ParseCsv(allergies), ParseCsv(preferred)), cancellationToken)));

        group.MapGet("/{id}", async (string id, ISender sender, CancellationToken cancellationToken) =>
            await sender.Send(new GetRecipeQuery(id), cancellationToken) is { } recipe
                ? Results.Ok(recipe)
                : Results.NotFound());
    }

    private static IReadOnlyList<string> ParseCsv(string? value) =>
        string.IsNullOrWhiteSpace(value)
            ? []
            : value.Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries);
}
