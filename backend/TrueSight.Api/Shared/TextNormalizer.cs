namespace TrueSight.Api.Shared;

public static class TextNormalizer
{
    public static string Ingredient(string value) =>
        string.Join(' ', value.Trim().ToLowerInvariant().Split(' ', StringSplitOptions.RemoveEmptyEntries));
}

