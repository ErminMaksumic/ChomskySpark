namespace Chomskyspark.Model
{
    public class RecognizedObject
    {
        public string Name { get; set; }
        public string Confidence { get; set; }
        public string X { get; set; }
        public string Y { get; set; }
        public string H { get; set; }
        public string W { get; set; }
        public bool IsAdultContent { get; set; }
        public bool IsGoryContent { get; set; }
        public bool IsRacyContent { get; set; }

    }
}
