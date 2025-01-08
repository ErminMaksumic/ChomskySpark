namespace Chomskyspark.Services.Database
{
    public class UserLanguage
    {
        public int UserId { get; set; }
        public virtual User User { get; set; }
        public int LanguageId { get; set; }
        public virtual Language Language { get; set; }
        public string Type { get; set; } = null!;
    }
}
