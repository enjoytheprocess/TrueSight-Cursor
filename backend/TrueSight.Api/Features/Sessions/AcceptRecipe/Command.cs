using MediatR;

namespace TrueSight.Api.Features.Sessions.AcceptRecipe;

public sealed record AcceptRecipeCommand(string RecipeId, int ServingMultiplier) : IRequest<RecipeSessionResponse>;

