using Chomskyspark.Services.Implementation;
using Chomskyspark.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
namespace Chomskyspark.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ObjectDetectionController : ControllerBase
    {
        public readonly IObjectDetectionService IObjectionService;
        public ObjectDetectionController(IObjectDetectionService IObjectionService)
        {
            this.IObjectionService = IObjectionService;
        }
        [HttpPost]
        public virtual Task<string[]> DetectImage([FromBody] string imageUrl)
        {
            return IObjectionService.DetectImage(imageUrl);
        }
    }
}