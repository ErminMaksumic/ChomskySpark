namespace Chomskyspark.Services.Interfaces
{
    public interface ILanguageService
    {
        string GetTranslatedWord(string word, string language);
    }
}