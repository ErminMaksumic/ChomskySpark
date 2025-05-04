using Azure.AI.OpenAI;
using Chomskyspark.Services.Interfaces;
using Microsoft.Extensions.Configuration;
using OpenAI.Images;
using System.ClientModel;
using Microsoft.EntityFrameworkCore;
using Chomskyspark.Services.Database;

namespace Chomskyspark.Services.Implementation
{
    public class ImageGeneratorService : IImageGeneratorService
    {
        private readonly string endpoint;
        private readonly string key;
        private readonly string model;
        private readonly string imageGeneratorPromptTemplate;
        private readonly ChomskySparkContext context;
        private readonly IWordForImageService wordForImageService;

        public ImageGeneratorService(IConfiguration configuration, IWordForImageService wordForImageService, ChomskySparkContext context)
        {
            this.endpoint = configuration["ImageGenerator:Endpoint"] ?? "";
            this.key = configuration["ImageGenerator:Key"] ?? "";
            this.model = configuration["ImageGenerator:Model"] ?? "";
            this.imageGeneratorPromptTemplate = configuration["OpenAI:ImageGeneratorPromptTemplate"] ?? "";
            this.context = context;
            this.wordForImageService = wordForImageService;
        }

        public async Task<string> GenerateImage(int userId)
        {
            var client = new AzureOpenAIClient(new Uri(endpoint), new ApiKeyCredential(key));

            ImageClient chatClient = client.GetImageClient(model);

            var wordsForImage = await wordForImageService.Get(new Model.SearchObjects.WordForImageSearchObject() { UserId = userId });
            var words = wordsForImage.Select(x => x.Name).ToArray();
            var prompt = string.Format(imageGeneratorPromptTemplate, string.Join(", ", words));

            var imageGeneration = await chatClient.GenerateImageAsync(
                prompt,
                new ImageGenerationOptions()
                {
                    Size = GeneratedImageSize.W1024xH1024
                }
            );

            return imageGeneration.Value.ImageUri.ToString();
        }

        public async Task<List<string>> GenerateLearnedWordsImages(int userId, int count = 5)
        {
            var client = new AzureOpenAIClient(new Uri(endpoint), new ApiKeyCredential(key));
            ImageClient chatClient = client.GetImageClient(model);

            // Get user's learned words
            var learnedWords = await context.LearnedWords
                .Where(x => x.UserId == userId)
                .Select(x => x.Word)
                .Distinct()
                .ToListAsync();

            if (!learnedWords.Any())
            {
                throw new Exception("No learned words found for this user");
            }

            var imageUrls = new List<string>();
            var random = new Random();

            for (int i = 0; i < count; i++)
            {
                var randomWord = learnedWords[random.Next(learnedWords.Count)];
                var prompt = string.Format(imageGeneratorPromptTemplate, randomWord);

                var imageGeneration = await chatClient.GenerateImageAsync(
                    prompt,
                    new ImageGenerationOptions()
                    {
                        Size = GeneratedImageSize.W1024xH1024
                    }
                );

                imageUrls.Add(imageGeneration.Value.ImageUri.ToString());
            }

            return imageUrls;
        }

        public async Task<int> GetLearnedWordsCount(int userId)
        {
            return await context.LearnedWords
                .Where(lw => lw.UserId == userId)
                .CountAsync();
        }
    }
}
