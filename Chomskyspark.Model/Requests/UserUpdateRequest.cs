using System.ComponentModel.DataAnnotations;

namespace Chomskyspark.Model.Requests
{
    public class UserUpdateRequest
    {
        [Required(AllowEmptyStrings = false), MaxLength(20)]
        public string Firstname { get; set; }
        [Required(AllowEmptyStrings = false), MaxLength(20)]
        public string Lastname { get; set; }

        [Required(AllowEmptyStrings = false)]
        [EmailAddress(), MaxLength(25)]
        public string Email { get; set; }
        [Required(AllowEmptyStrings = false), MaxLength(20)]
        public string Password { get; set; }
        [Required(AllowEmptyStrings = false), MaxLength(20)]
        public string PasswordConfirmation { get; set; }
        public int PrimaryLanguageId { get; set; }
        public int SecondaryLanguageId { get; set; }
    }
}
