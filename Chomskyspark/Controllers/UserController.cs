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

        [HttpGet("login")]
        [AllowAnonymous]
        public IActionResult Login(string username, string password)
        {
            var user = IUserService.Login(username, password);
            if (user == null)
            {
                return BadRequest("Not valid credentials!");
            }

            var token = IUserService.GenerateToken(user);
            return Ok(new { token = token, user = user });
        }

        [HttpGet("login-child")]
        [AllowAnonymous]
        public IActionResult Login(int id)
        {
            var user = IUserService.GetById(id);
            if (user == null)
            {
                return BadRequest("User doesn't exist!");
            }

            var token = IUserService.GenerateToken(user);
            return Ok(new { token = token, user = user });
        }

        [HttpGet("get-children/{parentId}")]
        [AllowAnonymous]
        public IEnumerable<Model.User> GetChildren(int parentId)
        {
            return IUserService.GetChildrenByParentIdAsync(parentId);
        }

        [HttpGet("get-dropdown-children/{parentId}")]
        [AllowAnonymous]
        public async Task<IEnumerable<KeyValuePair<int, string>>> GetDropdownChildren(int parentId)
        {
            return await IUserService.GetDropdownChildrenByParentIdAsync(parentId);
        }
    }
}