using FluentValidation;

namespace TrueSight.Api.Features.Inventory.CreateInventoryItem;

public sealed class Validator : AbstractValidator<CreateInventoryItemCommand>
{
    private static readonly string[] Units = ["count", "g", "kg", "ml", "l", "oz", "lb", "cup", "tbsp", "tsp"];

    public Validator()
    {
        RuleFor(command => command.Name).NotEmpty().MaximumLength(120);
        RuleFor(command => command.Quantity).GreaterThanOrEqualTo(0);
        RuleFor(command => command.Unit).NotEmpty().Must(unit => Units.Contains(unit.Trim().ToLowerInvariant()))
            .WithMessage("Unit must be one of: count, g, kg, ml, l, oz, lb, cup, tbsp, tsp.");
    }
}

