using FluentValidation;

namespace TrueSight.Api.Features.Sessions.AcceptRecipe;

public sealed class Validator : AbstractValidator<AcceptRecipeCommand>
{
    public Validator()
    {
        RuleFor(command => command.RecipeId).NotEmpty().MaximumLength(80);
        RuleFor(command => command.ServingMultiplier).InclusiveBetween(0.25m, 6m);
    }
}

