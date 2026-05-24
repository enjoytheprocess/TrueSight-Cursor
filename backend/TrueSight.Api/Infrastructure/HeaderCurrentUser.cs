namespace TrueSight.Api.Infrastructure;

public interface ICurrentUser
{
    string UserId { get; }
}

public sealed class HeaderCurrentUser(IHttpContextAccessor accessor, IWebHostEnvironment environment) : ICurrentUser
{
    public string UserId
    {
        get
        {
            var header = accessor.HttpContext?.Request.Headers["X-TrueSight-User"].FirstOrDefault();
            if (string.IsNullOrWhiteSpace(header))
            {
                if (environment.IsProduction())
                {
                    throw new InvalidOperationException("Production requests must include X-TrueSight-User.");
                }

                return "demo-user";
            }

            return header.Trim();
        }
    }
}
