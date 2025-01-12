using Chomskyspark.Model;
using Chomskyspark.Services.Database;
using Chomskyspark.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;
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
            return IObjectionService.DetectImageAsync(imageUrl, false);
        }

        [HttpGet]
        public virtual async Task<IActionResult> GetRandomRecognizedObject()
        {

#if DEBUG
            var images = new List<string>()
            {
                "https://api.thorhof-bestellungen.at/uploads/chomskyspark/find-object/1.jpg",
                "https://api.thorhof-bestellungen.at/uploads/chomskyspark/find-object/2.png",
                "https://api.thorhof-bestellungen.at/uploads/chomskyspark/find-object/3.jpg",
                "https://api.thorhof-bestellungen.at/uploads/chomskyspark/find-object/4.jpg",
                "https://api.thorhof-bestellungen.at/uploads/chomskyspark/find-object/5.png",
                "https://api.thorhof-bestellungen.at/uploads/chomskyspark/find-object/6.png",
                "https://api.thorhof-bestellungen.at/uploads/chomskyspark/find-object/7.png",
                "https://api.thorhof-bestellungen.at/uploads/chomskyspark/find-object/8.png",
                "https://api.thorhof-bestellungen.at/uploads/chomskyspark/find-object/9.png",
                "https://api.thorhof-bestellungen.at/uploads/chomskyspark/find-object/10.png",

            };

            var random = new Random();
            var imageUrl = images[random.Next(images.Count)];
            var recognizedObjects = await IObjectionService.DetectImageAsync(imageUrl, false);
#else
            var imagesFolder = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "uploads", "images");

            if (!Directory.Exists(imagesFolder))
            {
                throw new DirectoryNotFoundException("Folder with images does not exist.");
            }

            var imageFiles = Directory.GetFiles(imagesFolder);

            if (imageFiles.Length == 0)
            {
                throw new FileNotFoundException("No images found in the folder.");
            }

            var random = new Random();
            var randomImageFile = imageFiles[random.Next(imageFiles.Length)];
            var imageUrl = randomImageFile.Replace(Directory.GetCurrentDirectory(), "").Replace("\\", "/");
            var recognizedObjects = await IObjectionService.DetectImageAsync(imageUrl);
#endif

            return Ok(new { recognizedObjects, imageUrl });
        }
    }
}