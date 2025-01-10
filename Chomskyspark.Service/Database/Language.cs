namespace Chomskyspark.Services.Database
{
    public class Language
    {
        public int Id { get; set; }
        public string Name { get; set; } = null!;
        public string Code { get; set; }
        public virtual ICollection<UserLanguage> UserLanguages { get; set; }
              = new List<UserLanguage>();
    }
}
