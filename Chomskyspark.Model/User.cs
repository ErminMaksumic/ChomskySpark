namespace Chomskyspark.Model
{
    public  class User
    {
        public int Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public virtual ICollection<UserLanguage> UserLanguages { get; set; }
        public int? ParentUserId { get; set; }
    }
}
