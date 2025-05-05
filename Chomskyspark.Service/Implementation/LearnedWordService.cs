using AutoMapper;
using Chomskyspark.Model.Requests;
using Chomskyspark.Model.SearchObjects;
using Chomskyspark.Services.Database;
using Chomskyspark.Services.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace Chomskyspark.Services.Implementation
{
    public class LearnedWordService : CRUDService<Model.LearnedWord, BaseSearchObject, Database.LearnedWord, LearnedWordUpsertModel, LearnedWordUpsertModel>, ILearnedWordService
    {
        public LearnedWordService(ChomskySparkContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public async Task<int> GetCount(int userId)
        {
            return await Context.LearnedWords
                .Where(lw => lw.UserId == userId)
                .CountAsync();
        }

        public async Task<int> GetLearnedWordsCountByUserId(int userId)
        {
            return await Context.LearnedWords
                .Where(x => x.UserId == userId)
                .Select(x => x.Word)
                .Distinct()
                .CountAsync();
        }
    }
}
