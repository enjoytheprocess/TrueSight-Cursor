using MediatR;

namespace TrueSight.Api.Features.Sessions.AcceptRecipe;

public sealed record AcceptRecipeCommand(string RecipeId, decimal ServingMultiplier) : IRequest<RecipeSessionResponse>;

