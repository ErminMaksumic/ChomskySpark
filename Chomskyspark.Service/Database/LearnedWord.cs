namespace Chomskyspark.Services.Database
{
    public class LearnedWord
    {
        public int Id { get; set; }
        public int? UserId { get; set; }
        public string Word { get; set; } = string.Empty;
        public DateTime DateTime { get; set; } = DateTime.UtcNow;
    }
}
