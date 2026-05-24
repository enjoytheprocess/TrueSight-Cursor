using MediatR;
using TrueSight.Api.Infrastructure.Recipes;

namespace TrueSight.Api.Features.Recipes.GetRecipe;

public sealed class Handler(IRecipeProvider provider) : IRequestHandler<GetRecipeQuery, RecipeDto?>
{
    public Task<RecipeDto?> Handle(GetRecipeQuery request, CancellationToken cancellationToken) =>
        provider.GetRecipeAsync(request.Id, cancellationToken);
}

