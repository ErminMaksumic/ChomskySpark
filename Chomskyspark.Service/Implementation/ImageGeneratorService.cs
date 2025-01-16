using Azure.AI.OpenAI;
using Chomskyspark.Services.Interfaces;
using Microsoft.Extensions.Configuration;
using OpenAI.Images;
using System.ClientModel;

namespace Chomskyspark.Services.Implementation
{
    public class ImageGeneratorService(IConfiguration configuration, IWordForImageService wordForImageService) : IImageGeneratorService
    {
        private readonly string endpoint = configuration["ImageGenerator:Endpoint"] ?? "";
        private readonly string key = configuration["ImageGenerator:Key"] ?? "";
        private readonly string model = configuration["ImageGenerator:Model"] ?? "";
        private readonly string imageGeneratorPromptTemplate = configuration["OpenAI:ImageGeneratorPromptTemplate"] ?? "";

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
    }
}
