namespace Chomskyspark.Model.Requests
{
    public class LearnedWordUpsertModel
    {
        public int Id { get; set; }
        public int? UserId { get; set; }
        public string Word { get; set; } = string.Empty;
        public DateTime DateTime { get; set; } = DateTime.UtcNow;
    }
}
