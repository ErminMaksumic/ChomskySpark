namespace Chomskyspark.Services.Interfaces
{
    public interface IObjectSafetyService
    {
       string EvaluateObjectSafety(List<string> objects);
    }
}