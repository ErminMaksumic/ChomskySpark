using Azure.AI.OpenAI;
using Microsoft.Extensions.Configuration;
using Chomskyspark.Services.Interfaces;
using OpenAI.Chat;
using System.ClientModel;

namespace Chomskyspark.Services.Implementation
{
    public class SafetyService : ISafetyService
    {
        private readonly string endpoint;
        private readonly string key;
        private readonly string model;
        private readonly string objectPromptTemplate;
        private readonly string categoriesPromptTemplate;

        public SafetyService(IConfiguration configuration)
        {
            endpoint = configuration["OpenAI:Endpoint"] ?? "";
            key = configuration["OpenAI:Key"] ?? "";
            model = configuration["OpenAI:Model"] ?? "";
            objectPromptTemplate = configuration["OpenAI:ObjectPromptTemplate"] ?? "";
            categoriesPromptTemplate = configuration["OpenAI:CategoriesPromptTemplate"] ?? "";
        }

        public string EvaluateObjectSafety(List<string> objects)
        {
            string prompt = string.Format(objectPromptTemplate, string.Join(", ", objects));
            return GetCompletionForPrompt(prompt);
        }

        public string EvaluateCategoriesSafety(IEnumerable<string> categories)
        {
            string prompt = string.Format(categoriesPromptTemplate, string.Join(", ", categories));
            return GetCompletionForPrompt(prompt);
        }

        private string GetCompletionForPrompt(string prompt)
        {
            var azureClient = new AzureOpenAIClient(new Uri(endpoint), new ApiKeyCredential(key));
            ChatClient chatClient = azureClient.GetChatClient(model);

            ChatCompletion completion = chatClient.CompleteChat(
            [
                new UserChatMessage(prompt)
            ]);

            return completion.Content[0].Text;
        }
    }
}
