namespace Chomskyspark.Model
{
    public class UserLanguage
    {
        public int UserId { get; set; }
        public int LanguageId { get; set; }
        public Language Language { get; set; }
        public string Type { get; set; } = null!;
    }
}
