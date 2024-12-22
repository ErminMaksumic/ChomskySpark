using Chomskyspark.Model.Requests;
using Chomskyspark.Model.SearchObjects;
using Chomskyspark.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Chomskyspark.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
   // [Authorize]

    public class UserController : BaseCRUDController<Model.User, UserSearchObject,
         UserInsertRequest, UserUpdateRequest>
    {
        private readonly IUserService IUserService;
        public UserController(IUserService IUserService) :
            base(IUserService)
        {
            this.IUserService = IUserService;
        }
    }
}