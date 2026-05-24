using MediatR;
using Microsoft.AspNetCore.RateLimiting;
using TrueSight.Api.Features.ShoppingList.CreateShoppingListItem;
using TrueSight.Api.Features.ShoppingList.DeleteShoppingListItem;
using TrueSight.Api.Features.ShoppingList.ListShoppingListItems;
using TrueSight.Api.Features.ShoppingList.MoveShoppingListItemToInventory;
using TrueSight.Api.Infrastructure.Security;

namespace TrueSight.Api.Features.ShoppingList;

public static class ShoppingListEndpoints
{
    public static void MapShoppingListEndpoints(this IEndpointRouteBuilder routes)
    {
        var group = routes.MapGroup("/api/shopping-list").WithTags("ShoppingList")
            .RequireRateLimiting(ApiMutationRateLimiting.PolicyName);

        group.MapGet("/", async (ISender sender, CancellationToken cancellationToken) =>
            Results.Ok(await sender.Send(new ListShoppingListItemsQuery(), cancellationToken)));

        group.MapPost("/", async (CreateShoppingListItemRequest request, ISender sender, CancellationToken cancellationToken) =>
        {
            var item = await sender.Send(
                new CreateShoppingListItemCommand(request.Name, request.Quantity, request.Unit, request.SourceRecipeId),
                cancellationToken);
            return Results.Created($"/api/shopping-list/{item.Id}", item);
        });

        group.MapDelete("/{id:guid}", async (Guid id, ISender sender, CancellationToken cancellationToken) =>
            await sender.Send(new DeleteShoppingListItemCommand(id), cancellationToken)
                ? Results.NoContent()
                : Results.NotFound());

        group.MapPost("/{id:guid}/move-to-inventory", async (
            Guid id,
            MoveShoppingListItemToInventoryRequest request,
            ISender sender,
            CancellationToken cancellationToken) =>
            await sender.Send(new MoveShoppingListItemToInventoryCommand(id, request.ExpiryDate), cancellationToken) is { } item
                ? Results.Ok(item)
                : Results.NotFound());
    }
}
