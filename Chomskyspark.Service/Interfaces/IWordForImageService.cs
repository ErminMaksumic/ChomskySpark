using Chomskyspark.Model.Requests;
using Chomskyspark.Model.SearchObjects;

namespace Chomskyspark.Services.Interfaces
{
    public interface IWordForImageService : ICRUDService<Model.WordForImage, WordForImageSearchObject, WordForImageUpsertRequest, WordForImageUpsertRequest>
    {

    }
}