using Chomskyspark.Model;
using Chomskyspark.Model.Requests;
using Chomskyspark.Model.SearchObjects;

namespace Chomskyspark.Services.Interfaces
{
    public interface IUserService : ICRUDService<Model.User, UserSearchObject, UserInsertRequest, UserUpdateRequest>
    {
        User Login(string username, string password);
        string GenerateToken(Model.User user);
        IEnumerable<Model.User> GetChildrenByParentIdAsync(int parentId);
        Task<IEnumerable<KeyValuePair<int, string>>> GetDropdownChildrenByParentIdAsync(int parentId);
    }
}
