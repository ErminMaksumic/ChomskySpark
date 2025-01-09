using Chomskyspark.Model;
using Chomskyspark.Model.Requests;
using Chomskyspark.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
namespace Chomskyspark.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class LanguageController : ControllerBase
    {
        public readonly ILanguageService ILanguageService;
        public LanguageController(ILanguageService languageService)
        {
            this.ILanguageService = languageService;
        }

        [HttpPost]
        public virtual string getTranslatedWord([FromBody] LanguageRequest request)
        {
            return ILanguageService.GetTranslatedWord(request.Word, request.Language);
        }
    }
}