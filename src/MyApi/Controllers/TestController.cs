using Microsoft.AspNetCore.Mvc;

namespace MyApi.Controllers;

public class TestController : ControllerBase
{

    [HttpGet("test-httpclient")]
    public async Task<ActionResult> TestHttpClient([FromServices] IHttpClientFactory httpClientFactory)
    {
        var client = httpClientFactory.CreateClient();
        var response = await client.GetAsync("https://pokeapi.co/api/v2/ability/7/");
        var responseContent = await response.Content.ReadAsStringAsync();
        return Ok(responseContent);
    }
}