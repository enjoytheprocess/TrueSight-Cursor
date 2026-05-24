using MediatR;

namespace TrueSight.Api.Features.Recipes.ListRecipeSuggestions;

public sealed record ListRecipeSuggestionsQuery(IReadOnlyList<string> Allergies, IReadOnlyList<string> PreferredIngredients)
    : IRequest<IReadOnlyList<RecipeSuggestionResponse>>;
