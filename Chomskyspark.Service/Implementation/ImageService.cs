using Azure.AI.OpenAI;
using Chomskyspark.Model;
using Microsoft.Extensions.Configuration;
using Microsoft.Rest.Azure;
using OpenAI.Images;
using System.ClientModel;
using static System.Net.WebRequestMethods;


namespace Chomskyspark.Services.Implementation
{
    public class ImageService(IConfiguration configuration)
    {
        private readonly string endpoint = configuration["ImageGenerator:Endpoint"] ?? "";
        private readonly string key = configuration["ImageGenerator:Key"] ?? "";
        private readonly string model = configuration["ImageGenerator:MODEL"] ?? "";

        public async Task<string> GenerateImageAsync()
        {
            var azureClient = new AzureOpenAIClient(new Uri(endpoint), new ApiKeyCredential(key));

            ImageClient chatClient = azureClient.GetImageClient(model);

            var imageGeneration = await chatClient.GenerateImageAsync(
                    "chair",
                    new ImageGenerationOptions()
                    {
                        Size = GeneratedImageSize.W1024xH1024
                    }
                );

            Console.WriteLine(imageGeneration.Value.ImageUri);
            return imageGeneration.Value.ImageUri.ToString();
        }
    }
}
