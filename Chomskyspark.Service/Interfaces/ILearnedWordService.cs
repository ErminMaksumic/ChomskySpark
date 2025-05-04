using Chomskyspark.Model;
using Chomskyspark.Model.Requests;
using Chomskyspark.Model.SearchObjects;

namespace Chomskyspark.Services.Interfaces
{
    public interface ILearnedWordService : ICRUDService<LearnedWord, BaseSearchObject, LearnedWordUpsertModel, LearnedWordUpsertModel>
    {
    }
}
