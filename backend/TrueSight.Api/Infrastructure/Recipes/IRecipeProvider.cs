using TrueSight.Api.Features.Recipes;

namespace TrueSight.Api.Infrastructure.Recipes;

public interface IRecipeProvider
{
    Task<IReadOnlyList<RecipeDto>> GetRecipesAsync(CancellationToken cancellationToken);

    async Task<RecipeDto?> GetRecipeAsync(string id, CancellationToken cancellationToken) =>
        (await GetRecipesAsync(cancellationToken)).SingleOrDefault(recipe => recipe.Id == id);
}

