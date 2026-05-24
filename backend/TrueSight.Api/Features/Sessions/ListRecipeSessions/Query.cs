using MediatR;

namespace TrueSight.Api.Features.Sessions.ListRecipeSessions;

public sealed record ListRecipeSessionsQuery : IRequest<IReadOnlyList<RecipeSessionResponse>>;

