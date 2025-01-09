using Chomskyspark.Model;
using Chomskyspark.Model.Requests;
using Chomskyspark.Model.SearchObjects;
using Chomskyspark.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
namespace Chomskyspark.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class LanguageController : BaseController<Language, BaseSearchObject>
    {
        public readonly ILanguageService ILanguageService;
        public LanguageController(ILanguageService languageService) : base(languageService)
        {
            this.ILanguageService = languageService;
        }

        [AllowAnonymous]
        [HttpPost]
        public virtual string getTranslatedWord([FromBody] LanguageRequest request)
        {
            return ILanguageService.GetTranslatedWord(request.Word, request.Language);
        }

        [AllowAnonymous]
        public override Task<IEnumerable<Language>> Get([FromQuery] BaseSearchObject search)
        {
            return base.Get(search);
        }
    }
}