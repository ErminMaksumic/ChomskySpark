using Chomskyspark.Services.Implementation;
using Chomskyspark.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;

namespace Chomskyspark.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class NotificationController : ControllerBase
    {
        private readonly INotificationService INotificationService;

        public NotificationController(INotificationService INotificationService)
        {
            this.INotificationService = INotificationService;
        }

        [HttpPost("register-token")]
        public async Task<IActionResult> RegisterToken([FromForm] string token, [FromForm] string tag)
        {
            await INotificationService.RegisterDeviceAsync(token, tag);
            return Ok("Token registered successfully");
        }
    }
}