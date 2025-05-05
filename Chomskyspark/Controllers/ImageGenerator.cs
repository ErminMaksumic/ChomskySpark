using Chomskyspark.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Chomskyspark.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class ImageGenerator : ControllerBase
    {
        public readonly IImageGeneratorService IImageGeneratorService;
        public ImageGenerator(IImageGeneratorService IImageGeneratorService)
        {
            this.IImageGeneratorService = IImageGeneratorService;
        }

        [HttpGet("{childId}")]
        public virtual Task<string> GenerateImage(int childId)
        {
            return IImageGeneratorService.GenerateImage(childId);
        }
    }
}