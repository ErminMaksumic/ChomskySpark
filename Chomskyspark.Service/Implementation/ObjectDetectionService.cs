using Chomskyspark.Model;
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

        public async Task<IEnumerable<RecognizedObject>> DetectImageAsync(string imageUrl)
        {
            var client = new ComputerVisionClient(new ApiKeyServiceClientCredentials(key))
            {
                Endpoint = endpoint
            };

            ImageAnalysis analysis = await client.AnalyzeImageAsync(imageUrl, [VisualFeatureTypes.Objects, VisualFeatureTypes.Categories]);

            var detectedObjects = analysis.Objects.Select(o => new RecognizedObject
            {
                Name = o.ObjectProperty,
                X = o.Rectangle.X.ToString(),
                Y = o.Rectangle.Y.ToString(),
                H = o.Rectangle.H.ToString(),
                W = o.Rectangle.H.ToString(),
                Confidence = (o.Confidence * 100).ToString("F2"),
            }).ToList();

            return detectedObjects;
        }
    }
}
