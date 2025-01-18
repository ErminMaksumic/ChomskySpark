using Chomskyspark.Model.Requests;
using Chomskyspark.Model.SearchObjects;

namespace Chomskyspark.Services.Interfaces
{
    public interface ILearnedWordService: ICRUDService<Model.LearnedWord, BaseSearchObject, LearnedWordUpsertModel, LearnedWordUpsertModel>
    {
        public Task<int> GetLearnedWordsCountByUserId(int userId);
    }
}
