using Chomskyspark.Model.SearchObjects;

namespace Chomskyspark.Model.SearchObjects
{
    public class LearnedWordSearchObject : BaseSearchObject
    {
        public int? UserId { get; set; }
        public int? CategoryId { get; set; }
    }
} 