using MediatR;
using Microsoft.EntityFrameworkCore;
using TrueSight.Api.Infrastructure;
using TrueSight.Api.Infrastructure.Data;

namespace TrueSight.Api.Features.Sessions.ListRecipeSessions;

public sealed class Handler(TrueSightDbContext db, ICurrentUser currentUser)
    : IRequestHandler<ListRecipeSessionsQuery, IReadOnlyList<RecipeSessionResponse>>
{
    public async Task<IReadOnlyList<RecipeSessionResponse>> Handle(ListRecipeSessionsQuery request, CancellationToken cancellationToken)
    {
        var sessions = await db.RecipeSessions
            .AsNoTracking()
            .Include(session => session.Lines)
            .Where(session => session.UserId == currentUser.UserId)
            .ToListAsync(cancellationToken);

        // SQLite cannot translate ORDER BY on DateTimeOffset; sort in memory after fetch.
        return sessions
            .OrderByDescending(session => session.AcceptedAt)
            .Select(session => new RecipeSessionResponse(
                session.Id,
                session.RecipeId,
                session.RecipeName,
                session.ServingMultiplier,
                session.AcceptedAt,
                session.Lines
                    .Select(line => new RecipeSessionLineResponse(line.IngredientName, line.QuantityDeducted, line.Unit))
                    .ToList()))
            .ToList();
    }
}

