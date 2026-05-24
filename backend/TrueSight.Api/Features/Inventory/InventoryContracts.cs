namespace TrueSight.Api.Features.Inventory;

public sealed record InventoryItemResponse(
    Guid Id,
    string Name,
    decimal Quantity,
    string Unit,
    DateOnly? ExpiryDate,
    DateTimeOffset AddedAt,
    DateTimeOffset UpdatedAt);

public sealed record CreateInventoryItemRequest(string Name, decimal Quantity, string Unit, DateOnly? ExpiryDate);

public sealed record UpdateInventoryItemRequest(string Name, decimal Quantity, string Unit, DateOnly? ExpiryDate);

