using TrueSight.Api.Features.Recipes;

namespace TrueSight.Api.Infrastructure.Recipes;

public sealed class StaticRecipeProvider : IRecipeProvider
{
    private static readonly RecipeDto[] Recipes =
    [
        new(
            "chicken-spinach-eggs",
            "Chicken Spinach Scramble",
            "A fast skillet meal that uses proteins and greens before they turn.",
            "Everyday",
            "Easy",
            20,
            2,
            [
                new("chicken", 300, "g"),
                new("spinach", 120, "g"),
                new("eggs", 2, "count"),
                new("cheese", 40, "g")
            ],
            ["Cook chicken pieces until browned.", "Wilt spinach in the skillet.", "Add beaten eggs and finish with cheese."]),
        new(
            "vegetable-omelette",
            "Vegetable Omelette",
            "A flexible breakfast-for-dinner option for small fridge odds and ends.",
            "Everyday",
            "Easy",
            15,
            1,
            [
                new("eggs", 2, "count"),
                new("spinach", 60, "g"),
                new("cheese", 30, "g"),
                new("tomato", 1, "count")
            ],
            ["Whisk eggs.", "Cook fillings briefly.", "Fold eggs around the vegetables and cheese."]),
        new(
            "tomato-pasta",
            "Tomato Pasta",
            "A pantry-friendly pasta that welcomes fresh tomato and cheese.",
            "Italian",
            "Easy",
            25,
            2,
            [
                new("pasta", 200, "g"),
                new("tomato", 2, "count"),
                new("cheese", 50, "g")
            ],
            ["Boil pasta.", "Simmer chopped tomato into a quick sauce.", "Toss together and top with cheese."]),
        new(
            "yogurt-berry-bowl",
            "Yogurt Berry Bowl",
            "A no-cook snack that clears dairy and fruit quickly.",
            "Everyday",
            "Easy",
            5,
            1,
            [
                new("yogurt", 180, "g"),
                new("berries", 80, "g"),
                new("oats", 30, "g")
            ],
            ["Spoon yogurt into a bowl.", "Top with berries and oats."])
    ];

    public Task<IReadOnlyList<RecipeDto>> GetRecipesAsync(CancellationToken cancellationToken) =>
        Task.FromResult<IReadOnlyList<RecipeDto>>(Recipes);
}
