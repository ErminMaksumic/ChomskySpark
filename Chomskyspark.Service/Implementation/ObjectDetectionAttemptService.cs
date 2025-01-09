using AutoMapper;
using Chomskyspark.Model.Requests;
using Chomskyspark.Model.SearchObjects;
using Chomskyspark.Services.Database;
using Chomskyspark.Services.Interfaces;

namespace Chomskyspark.Services.Implementation
{
    public class ObjectDetectionAttemptService : CRUDService<Model.ObjectDetectionAttempt, BaseSearchObject, Database.ObjectDetectionAttempt, ObjectDetectionAttemptUpsertRequest, ObjectDetectionAttemptUpsertRequest>, IObjectDetectionAttemptService
    {
        public ObjectDetectionAttemptService(ChomskySparkContext context, IMapper mapper) : base(context, mapper)
        {

        }

        public override Model.ObjectDetectionAttempt Insert(ObjectDetectionAttemptUpsertRequest request)
        {
            if (request.Success) 
            { 
                Context.LearnedWords.Add(IMapper.Map<LearnedWord>(request));
            }
            return base.Insert(request);
        }
    }
}
