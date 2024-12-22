using AutoMapper;
using Chomskyspark.Model.Requests;
using Chomskyspark.Model.SearchObjects;
using Chomskyspark.Services.Database;
using Chomskyspark.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Chomskyspark.Services.Implementation
{
    public class UserService : CRUDService<Model.User, UserSearchObject, User, UserInsertRequest, UserUpdateRequest>, IUserService
    {
        public UserService(ChomskySparkContext context, IMapper mapper) : base(context, mapper)
        { }
    }
}