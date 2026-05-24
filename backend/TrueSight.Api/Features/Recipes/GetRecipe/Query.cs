using MediatR;

namespace TrueSight.Api.Features.Recipes.GetRecipe;

public sealed record GetRecipeQuery(string Id) : IRequest<RecipeDto?>;

