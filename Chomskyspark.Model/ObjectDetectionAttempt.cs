namespace Chomskyspark.Model
{
    public class ObjectDetectionAttempt
    {
        public int Id { get; set; }
        public int? UserId { get; set; }
        public string TargetWord { get; set; } = string.Empty;
        public string SelectedWord { get; set; } = string.Empty;
        public bool Success { get; set; }
        public int AttemptNumber { get; set; }
        public int ElapsedTimeInSeconds { get; set; }
        public DateTime Timestamp { get; set; } = DateTime.UtcNow;
    }
}
