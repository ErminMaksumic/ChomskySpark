using Azure.AI.OpenAI;
using OpenAI.Chat;
using System.ClientModel;
using Microsoft.Extensions.Configuration;
using Chomskyspark.Services.Interfaces;

namespace Chomskyspark.Services.Implementation
{
    public class ObjectSafetyService(IConfiguration configuration) : IObjectSafetyService
    {
        private readonly string endpoint = configuration["OpenAI:Endpoint"] ?? "";
        private readonly string key = configuration["OpenAI:Key"] ?? "";
        private readonly string model = configuration["OpenAI:Model"] ?? "";
        private readonly string promptTemplate = configuration["OpenAI:PromptTemplate"] ?? "";

        public string EvaluateObjectSafety(List<string> objects)
        {
            var azureClient = new AzureOpenAIClient(
              new Uri(endpoint),
              new ApiKeyCredential(key)
            );

            ChatClient chatClient = azureClient.GetChatClient(model);

            string prompt = string.Format(promptTemplate, string.Join(", ", objects));

            ChatCompletion completion = chatClient.CompleteChat(
            [
                new UserChatMessage(prompt)
            ]);

            return completion.Content[0].Text;
        }
    }
}