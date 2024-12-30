using Chomskyspark.Services.Interfaces;
using Microsoft.Azure.CognitiveServices.Vision.ComputerVision;
using Microsoft.Azure.CognitiveServices.Vision.ComputerVision.Models;
using Microsoft.Extensions.Configuration;
namespace Chomskyspark.Services.Implementation
{
    public class ObjectDetectionService(IConfiguration configuration) : IObjectDetectionService
    {
        private readonly string endpoint = configuration["ObjectDetection:Endpoint"] ?? "";
        private readonly string key = configuration["ObjectDetection:Key"] ?? "";
        public async Task<string[]> DetectImage(string imageUrl)
        {
            var client = new ComputerVisionClient(new ApiKeyServiceClientCredentials(key))
            {
                Endpoint = endpoint
            };
            ImageAnalysis analysis = await client.AnalyzeImageAsync(imageUrl, new List<VisualFeatureTypes?> { VisualFeatureTypes.Objects });
            IList<DetectedObject> detectedObjects = analysis.Objects;
            if (detectedObjects.Count > 0)
            {
                foreach (var detectedObject in detectedObjects)
                {
                    Console.WriteLine($"Object: {detectedObject.ObjectProperty}, Confidence: {detectedObject.Confidence}, " +
                                      $"Bounding Box: {detectedObject.Rectangle.X}, {detectedObject.Rectangle.Y}, " +
                                      $"{detectedObject.Rectangle.W}, {detectedObject.Rectangle.H}");
                }
            }
            else
            {
                Console.WriteLine("No objects detected.");
            }
            string[] objectNames = detectedObjects.Select(o => o.ObjectProperty).ToArray();
            return objectNames;
        }
    }
}