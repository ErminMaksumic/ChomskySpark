using Chomskyspark.Model;
using Chomskyspark.Services.Interfaces;
using Microsoft.Azure.CognitiveServices.Vision.ComputerVision;
using Microsoft.Azure.CognitiveServices.Vision.ComputerVision.Models;
using Microsoft.Extensions.Configuration;

namespace Chomskyspark.Services.Implementation
{
    public class ObjectDetectionService(IConfiguration configuration, ISafetyService ISafetyService) : IObjectDetectionService
    {
        private readonly string endpoint = configuration["ObjectDetection:Endpoint"] ?? "";
        private readonly string key = configuration["ObjectDetection:Key"] ?? "";
        private readonly string[] restrictedObjects = configuration["ObjectDetection:RestrictedObjects"]?.Split(",") ?? [];

        public async Task<IEnumerable<RecognizedObject>> DetectImageAsync(string imageUrl, bool evaluateCategoriesSafety)
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
                })
                .Where(o => !restrictedObjects.Contains(o.Name.ToLower()))
                .DistinctBy(o => o.Name
                ).ToList();

            // todo - check if needed
            if (evaluateCategoriesSafety)
            {
                var checkedSafety = ISafetyService.EvaluateCategoriesSafety(analysis.Categories.Select(o=> o.Name));
            }

            return detectedObjects;
        }
    }
}
