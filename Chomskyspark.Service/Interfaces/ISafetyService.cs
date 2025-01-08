namespace Chomskyspark.Services.Interfaces
{
    public interface ISafetyService
    {
       string EvaluateObjectSafety(List<string> objects);
       string EvaluateCategoriesSafety(IEnumerable<string> categories);
    }
}