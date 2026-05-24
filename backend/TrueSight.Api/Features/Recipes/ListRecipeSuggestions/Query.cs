using MediatR;

namespace TrueSight.Api.Features.Recipes.ListRecipeSuggestions;

public sealed record ListRecipeSuggestionsQuery : IRequest<IReadOnlyList<RecipeSuggestionResponse>>;

