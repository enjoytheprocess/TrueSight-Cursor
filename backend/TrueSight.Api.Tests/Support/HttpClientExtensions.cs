using System.Net.Http.Json;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace TrueSight.Api.Tests.Support;

internal static class HttpClientExtensions
{
    internal static readonly JsonSerializerOptions JsonOptions = new()
    {
        PropertyNameCaseInsensitive = true,
        Converters = { new JsonStringEnumConverter() },
    };

    internal static HttpClient ForUser(this HttpClient client, string userId)
    {
        client.DefaultRequestHeaders.Remove("X-TrueSight-User");
        client.DefaultRequestHeaders.Add("X-TrueSight-User", userId);
        return client;
    }

    internal static async Task<T?> ReadJsonAsync<T>(this HttpResponseMessage response)
    {
        await using var stream = await response.Content.ReadAsStreamAsync();
        return await JsonSerializer.DeserializeAsync<T>(stream, JsonOptions);
    }

    internal static Task<HttpResponseMessage> PutJsonAsync<T>(this HttpClient client, string path, T payload) =>
        client.PutAsJsonAsync(path, payload, JsonOptions);

    internal static Task<HttpResponseMessage> PostJsonAsync<T>(this HttpClient client, string path, T payload) =>
        client.PostAsJsonAsync(path, payload, JsonOptions);
}
