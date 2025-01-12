using Chomskyspark.Model;

namespace Chomskyspark.Services.Interfaces
{
    public interface IObjectDetectionService
    {
        Task<IEnumerable<RecognizedObject>> DetectImageAsync(string imageUrl, bool evaluateCategoriesSafety);
    }
}