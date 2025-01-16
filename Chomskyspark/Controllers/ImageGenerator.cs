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

        [HttpGet]
        public virtual Task<string> GenerateImage()
        {
            return IImageGeneratorService.GenerateImage(int.Parse(HttpContext.Items["UserId"] as string));
        }
    }
}