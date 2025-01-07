using Chomskyspark.Model;
using Chomskyspark.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
namespace Chomskyspark.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ObjectDetectionController : ControllerBase
    {
        public readonly IObjectDetectionService IObjectionService;
        public ObjectDetectionController(IObjectDetectionService IObjectionService)
        {
            this.IObjectionService = IObjectionService;
        }
        [HttpPost]
        public virtual Task<IEnumerable<RecognizedObject>> DetectImage([FromBody] string imageUrl)
        {
            return IObjectionService.DetectImageAsync(imageUrl);
        }
    }
}