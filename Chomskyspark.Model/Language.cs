using Chomskyspark.Model;

namespace Chomskyspark.Model
{
    public class Language
    {
        public int Id { get; set; }
        public string Name { get; set; } = null!;
        public virtual ICollection<UserLanguage> UserLanguages { get; set; }
    }
}
