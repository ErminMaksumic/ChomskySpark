namespace Chomskyspark.Services.Interfaces
{
    public interface IImageGeneratorService
    {
        Task<string> GenerateImage(int userId);
    }
}