using Chomskyspark.Model.SearchObjects;

namespace Chomskyspark.Services.Interfaces
{
    public interface ILanguageService : IBaseService<Model.Language, BaseSearchObject>
    {
        string GetTranslatedWord(string word, string language);
    }
}