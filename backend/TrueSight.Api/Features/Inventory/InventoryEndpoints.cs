using MediatR;
using TrueSight.Api.Features.Inventory.CreateInventoryItem;
using TrueSight.Api.Features.Inventory.DeleteInventoryItem;
using TrueSight.Api.Features.Inventory.GetInventoryItem;
using TrueSight.Api.Features.Inventory.ListInventoryItems;
using TrueSight.Api.Features.Inventory.UpdateInventoryItem;

namespace TrueSight.Api.Features.Inventory;

public static class InventoryEndpoints
{
    public static void MapInventoryEndpoints(this IEndpointRouteBuilder routes)
    {
        var group = routes.MapGroup("/api/inventory").WithTags("Inventory");

        group.MapGet("/", async (ISender sender, CancellationToken cancellationToken) =>
            Results.Ok(await sender.Send(new ListInventoryItemsQuery(), cancellationToken)));

        group.MapGet("/{id:guid}", async (Guid id, ISender sender, CancellationToken cancellationToken) =>
            await sender.Send(new GetInventoryItemQuery(id), cancellationToken) is { } item
                ? Results.Ok(item)
                : Results.NotFound());

        group.MapPost("/", async (CreateInventoryItemRequest request, ISender sender, CancellationToken cancellationToken) =>
        {
            var item = await sender.Send(new CreateInventoryItemCommand(request.Name, request.Quantity, request.Unit, request.ExpiryDate), cancellationToken);
            return Results.Created($"/api/inventory/{item.Id}", item);
        });

        group.MapPut("/{id:guid}", async (Guid id, UpdateInventoryItemRequest request, ISender sender, CancellationToken cancellationToken) =>
            await sender.Send(new UpdateInventoryItemCommand(id, request.Name, request.Quantity, request.Unit, request.ExpiryDate), cancellationToken) is { } item
                ? Results.Ok(item)
                : Results.NotFound());

        group.MapDelete("/{id:guid}", async (Guid id, ISender sender, CancellationToken cancellationToken) =>
            await sender.Send(new DeleteInventoryItemCommand(id), cancellationToken)
                ? Results.NoContent()
                : Results.NotFound());
    }
}

