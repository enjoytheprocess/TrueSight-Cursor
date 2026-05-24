namespace TrueSight.Api.Infrastructure;

public interface ICurrentUser
{
    string UserId { get; }
}

public sealed class HeaderCurrentUser(IHttpContextAccessor accessor) : ICurrentUser
{
    public string UserId
    {
        get
        {
            var header = accessor.HttpContext?.Request.Headers["X-TrueSight-User"].FirstOrDefault();
            return string.IsNullOrWhiteSpace(header) ? "demo-user" : header.Trim();
        }
    }
}

