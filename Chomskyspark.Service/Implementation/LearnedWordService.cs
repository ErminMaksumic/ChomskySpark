using AutoMapper;
using Chomskyspark.Model.Requests;
using Chomskyspark.Model.SearchObjects;
using Chomskyspark.Services.Database;
using Chomskyspark.Services.Interfaces;

namespace Chomskyspark.Services.Implementation
{
    public class LearnedWordService : CRUDService<Model.LearnedWord, BaseSearchObject, Database.LearnedWord, LearnedWordUpsertModel, LearnedWordUpsertModel>, ILearnedWordService
    {
        public LearnedWordService(ChomskySparkContext context, IMapper mapper) : base(context, mapper)
        {

        }
    }
}
