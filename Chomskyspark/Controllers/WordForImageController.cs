using Chomskyspark.Model;
using Chomskyspark.Model.Requests;
using Chomskyspark.Model.SearchObjects;
using Chomskyspark.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Chomskyspark.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]

    public class WordForImageController : BaseCRUDController<WordForImage, WordForImageSearchObject, WordForImageUpsertRequest, WordForImageUpsertRequest>
    {
        private readonly IWordForImageService IWordForImageService;
        public WordForImageController(IWordForImageService IWordForImageService) :
            base(IWordForImageService)
        {
            this.IWordForImageService = IWordForImageService;
        }
    }
}