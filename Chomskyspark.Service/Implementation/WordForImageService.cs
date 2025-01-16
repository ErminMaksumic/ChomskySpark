using AutoMapper;
using Chomskyspark.Model.Requests;
using Chomskyspark.Model.SearchObjects;
using Chomskyspark.Services.Database;
using Chomskyspark.Services.Interfaces;

namespace Chomskyspark.Services.Implementation
{
    public class WordForImageService : CRUDService<Model.WordForImage, WordForImageSearchObject, Database.WordForImage, WordForImageUpsertRequest, WordForImageUpsertRequest>, IWordForImageService
    {
        public WordForImageService(ChomskySparkContext context, IMapper mapper) : base(context, mapper)
        {

        }

        public override IQueryable<WordForImage> AddInclude(IQueryable<WordForImage> query, WordForImageSearchObject searchObject = null)
        {
            var includedQuery = base.AddInclude(query, searchObject);

            if (searchObject.UserId != 0)
            {
                includedQuery = includedQuery.Where(x => x.UserId == searchObject.UserId);
            }
            return includedQuery;
        }
    }
}
