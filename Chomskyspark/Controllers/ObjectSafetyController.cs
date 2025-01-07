using Chomskyspark.Model;
using Chomskyspark.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
namespace Chomskyspark.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ObjectSafetyController : ControllerBase
    {
        public readonly IObjectSafetyService IObjectSafetyService;
        public ObjectSafetyController(IObjectSafetyService IObjectSafetyService)
        {
            this.IObjectSafetyService = IObjectSafetyService;
        }
        [HttpPost]
        public virtual string EvaluateObjectSafety([FromBody] List<string> objects)
        {
            return IObjectSafetyService.EvaluateObjectSafety(objects);
        }
    }
}