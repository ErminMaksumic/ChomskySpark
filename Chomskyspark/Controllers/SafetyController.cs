using Chomskyspark.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;
namespace Chomskyspark.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class SafetyController : ControllerBase
    {
        public readonly ISafetyService ISafetyService;
        public SafetyController(ISafetyService ISafetyService)
        {
            this.ISafetyService = ISafetyService;
        }
        [HttpPost("object")]
        public virtual string EvaluateObjectSafety([FromBody] List<string> objects)
        {
            return ISafetyService.EvaluateObjectSafety(objects);
        }
        [HttpPost("categories")]
        public virtual string EvaluateCategoriesSafety([FromBody] List<string> categories)
        {
            return ISafetyService.EvaluateCategoriesSafety(categories);
        }
    }
}