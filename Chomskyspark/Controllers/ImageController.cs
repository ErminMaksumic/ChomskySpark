using Chomskyspark.Services.Implementation;
using Chomskyspark.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;
namespace Chomskyspark.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ImageController : ControllerBase
    {
        public readonly ImageService ImageService;
        public ImageController(ImageService imageService)
        {
            ImageService = imageService;
        }
        [HttpGet("imageDetect")]
        public virtual Task<string> GenerateImageAsync()
        {
            return ImageService.GenerateImageAsync();
        }
      
    }
}