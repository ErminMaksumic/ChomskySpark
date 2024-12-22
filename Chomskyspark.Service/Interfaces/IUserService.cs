using Chomskyspark.Model.Requests;
using Chomskyspark.Model.SearchObjects;

namespace Chomskyspark.Services.Interfaces
{
    public interface IUserService : ICRUDService<Model.User, UserSearchObject, UserInsertRequest, UserUpdateRequest>
    { }
}
