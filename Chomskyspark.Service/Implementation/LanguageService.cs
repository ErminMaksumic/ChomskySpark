using AutoMapper;
using Azure.AI.OpenAI;
using Chomskyspark.Model;
using Chomskyspark.Model.SearchObjects;
using Chomskyspark.Services.Interfaces;
using Microsoft.Extensions.Configuration;
using OpenAI.Chat;
using System.ClientModel;

namespace Chomskyspark.Services.Implementation
{
    public class LanguageService : BaseService<Language, BaseSearchObject, Database.Language>, ILanguageService
    {
        private readonly string endpoint;
        private readonly string key;
        private readonly string model;
        private readonly string languagePrompt;

        public LanguageService(Database.ChomskySparkContext context, IMapper mapper, IConfiguration configuration) : base(context, mapper)
        {
            endpoint = configuration["OpenAI:Endpoint"] ?? "";
            key = configuration["OpenAI:Key"] ?? "";
            model = configuration["OpenAI:Model"] ?? "";
            languagePrompt = configuration["OpenAI:LanguagePrompt"] ?? "";
        }

        public string GetTranslatedWord(string word, string language)
        {
            string prompt = string.Format(languagePrompt, word, language);

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

            return completion.Content[0].Text.ToString();
        }

    }
}
