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

    public class ObjectDetectionAttemptController : BaseCRUDController<ObjectDetectionAttempt, BaseSearchObject,
         ObjectDetectionAttemptUpsertRequest, ObjectDetectionAttemptUpsertRequest>
    {
        private readonly IObjectDetectionAttemptService IObjectDetectionAttemptService;
        public ObjectDetectionAttemptController(IObjectDetectionAttemptService IObjectDetectionAttemptService) :
            base(IObjectDetectionAttemptService)
        {
            this.IObjectDetectionAttemptService = IObjectDetectionAttemptService;
        }
        [AllowAnonymous]
        public override ObjectDetectionAttempt Insert([FromBody] ObjectDetectionAttemptUpsertRequest request)
        {
            return base.Insert(request);
        }
    }
}