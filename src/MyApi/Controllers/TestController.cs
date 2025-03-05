using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Caching.Memory;

namespace MyApi.Controllers;

public class TestController : ControllerBase
{
    [HttpGet("test")]
    public ActionResult Get([FromServices] IMemoryCache memoryCache)
    {
        memoryCache.Set("test", "test");
        return Ok(Guid.NewGuid().ToString());
    }
}