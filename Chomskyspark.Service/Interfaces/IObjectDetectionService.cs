using Chomskyspark.Model;
using Newtonsoft.Json.Linq;

namespace Chomskyspark.Services.Interfaces
{
    public interface IObjectDetectionService
    {
        Task<IEnumerable<RecognizedObject>> DetectImageAsync(string imageUrl, bool evaluateCategoriesSafety, string token);
    }
}