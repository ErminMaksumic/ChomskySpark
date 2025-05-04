namespace Chomskyspark.Services.Interfaces
{
    public interface IImageGeneratorService
    {
        Task<string> GenerateImage(int userId);
        Task<List<string>> GenerateLearnedWordsImages(int userId, int count = 5);
        Task<int> GetLearnedWordsCount(int userId);
    }
}