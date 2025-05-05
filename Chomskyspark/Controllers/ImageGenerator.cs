using Chomskyspark.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

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

        [HttpGet("learned-words")]
        public virtual async Task<IActionResult> GenerateLearnedWordsImages([FromQuery] int count = 5)
        {
            try
            {
                var userId = int.Parse(HttpContext.Items["UserId"] as string);
                var imageUrls = await IImageGeneratorService.GenerateLearnedWordsImages(userId, count);
                return Ok(imageUrls);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpGet("count")]
        public virtual async Task<int> GetCount()
        {
            var userId = int.Parse(HttpContext.Items["UserId"] as string);
            return await IImageGeneratorService.GetLearnedWordsCount(userId);
        }

        [HttpGet("story-strip")]
        public virtual async Task<List<string>> GenerateStoryStripImages([FromQuery] int count = 5)
        {
            var userId = int.Parse(HttpContext.Items["UserId"] as string);
            return await IImageGeneratorService.GenerateLearnedWordsImages(userId, count);
        }
    }
}