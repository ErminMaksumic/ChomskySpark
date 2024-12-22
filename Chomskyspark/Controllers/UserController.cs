using AdventuraClick.Authorization;
using Chomskyspark.Model;
using Chomskyspark.Model.Requests;
using Chomskyspark.Model.SearchObjects;
using Chomskyspark.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Chomskyspark.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]

    public class UserController : BaseCRUDController<Model.User, UserSearchObject,
         UserInsertRequest, UserUpdateRequest>
    {
        private readonly IUserService IUserService;
        public UserController(IUserService IUserService) :
            base(IUserService)
        {
            this.IUserService = IUserService;
        }

        [AllowAnonymous]
        public override User Insert([FromBody] UserInsertRequest request)
        {
            return base.Insert(request);
        }

        [HttpGet("login"), AllowAnonymous]
        public Model.User Login()
        {
            var credentials = CredentialsHelper.extractCredentials(Request);

            return IUserService.Login(credentials.Username, credentials.Password);
        }
    }
}