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

    public class LearnedWordController : BaseCRUDController<LearnedWord, BaseSearchObject,
         LearnedWordUpsertModel, LearnedWordUpsertModel>
    {
        private readonly ILearnedWordService ILearnedWordService;
        public LearnedWordController(ILearnedWordService ILearnedWordService) :
            base(ILearnedWordService)
        {
            this.ILearnedWordService = ILearnedWordService;
        }

        [HttpGet("get-learned-words-count-by-user-id/{userId}")]
        public async Task<int> RegisterToken(int userId)
        {
            return await ILearnedWordService.GetLearnedWordsCountByUserId(userId);
        }
    }
}