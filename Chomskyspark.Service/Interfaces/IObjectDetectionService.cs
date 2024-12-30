namespace Chomskyspark.Services.Interfaces
{
    public interface IObjectDetectionService
    {
        public Task<string[]> DetectImage(string imageUrl);
    }
}

