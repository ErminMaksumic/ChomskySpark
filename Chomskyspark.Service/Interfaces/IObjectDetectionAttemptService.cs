using Chomskyspark.Model;
using Chomskyspark.Model.Requests;
using Chomskyspark.Model.SearchObjects;

namespace Chomskyspark.Services.Interfaces
{
    public interface IObjectDetectionAttemptService : ICRUDService<Model.ObjectDetectionAttempt, BaseSearchObject, ObjectDetectionAttemptUpsertRequest, ObjectDetectionAttemptUpsertRequest>
    {

    }
}
