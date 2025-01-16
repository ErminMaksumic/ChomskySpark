using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Chomskyspark.Services.Database
{
    public class User
    {
        public int Id { get; set; }
        public string Firstname { get; set; }
        public string Lastname { get; set; }
        public string Email { get; set; }
        public string PasswordHash { get; set; }
        public string PasswordSalt { get; set; }
        public virtual ICollection<UserLanguage> UserLanguages { get; set; }

        public int? ParentUserId { get; set; }
        public virtual User ParentUser { get; set; }
        public virtual ICollection<User> ChildUsers { get; set; }

    }
}
