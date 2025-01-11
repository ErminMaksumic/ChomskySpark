using Chomskyspark.Model;
using Chomskyspark.Services.Interfaces;
using Microsoft.Azure.CognitiveServices.Vision.ComputerVision;
using Microsoft.Azure.CognitiveServices.Vision.ComputerVision.Models;
using Microsoft.Extensions.Configuration;
using System.Text.Json;

namespace Chomskyspark.Services.Implementation
{
    public class ObjectDetectionService(IConfiguration configuration, ISafetyService ISafetyService) : IObjectDetectionService
    {
        private readonly INotificationService INotificationService;
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


            List<string> objectNames = detectedObjects.Select(obj => obj.Name).ToList();
            var checkedSafety = ISafetyService.EvaluateObjectSafety(objectNames);
            List<RiskLevel> dangerousObjects = JsonSerializer.Deserialize<List<RiskLevel>>(checkedSafety);

            foreach (var obj in dangerousObjects)
            {
                if (obj.Level == "High")
                {
                    await INotificationService.SendNotificationAsync($"Dangerous object detected: {obj.Name}", "2");
                }
            }

            return detectedObjects;
        }
    }
}
