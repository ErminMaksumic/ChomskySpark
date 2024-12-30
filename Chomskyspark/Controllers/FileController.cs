using Chomskyspark.Services.FileManager;
using Microsoft.AspNetCore.Mvc;

namespace Chomskyspark.Controllers
{
    //Test version
    [Route("api/[controller]")]
    [ApiController]
    public class FileController : ControllerBase
    {
        private readonly IFileManager fileManager;

        public FileController(IFileManager fileManager)
        {
            this.fileManager = fileManager;
        }

        [HttpPost]
        public async Task<IActionResult> Upload(IFormFile formFile)
        {
            return Ok(await fileManager.UploadFile(formFile));
        }
    }
}
