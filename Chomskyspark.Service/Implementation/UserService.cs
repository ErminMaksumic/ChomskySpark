using AutoMapper;
using Chomskyspark.Model;
using Chomskyspark.Model.Helpers;
using Chomskyspark.Model.Requests;
using Chomskyspark.Model.SearchObjects;
using Chomskyspark.Services.Database;
using Chomskyspark.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
using System.Security.Cryptography;
using System.Text;
using User = Chomskyspark.Services.Database.User;

namespace Chomskyspark.Services.Implementation
{
    public class UserService : CRUDService<Model.User, UserSearchObject, User, UserInsertRequest, UserUpdateRequest>, IUserService
    {
        private readonly IJWTService jWTService;

        public UserService(ChomskySparkContext context, IMapper mapper, IJWTService jWTService) : base(context, mapper)
        {
            this.jWTService = jWTService;
        }

        public static string GenerateSalt()
        {
            RNGCryptoServiceProvider provider = new RNGCryptoServiceProvider();
            var byteArray = new byte[16];
            provider.GetBytes(byteArray);


            return Convert.ToBase64String(byteArray);
        }

        public static string GenerateHash(string salt, string password)
        {
            byte[] src = Convert.FromBase64String(salt);

            byte[] bytes = Encoding.Unicode.GetBytes(password);

            byte[] dst = new byte[src.Length + bytes.Length];

            System.Buffer.BlockCopy(src, 0, dst, 0, src.Length);
            System.Buffer.BlockCopy(bytes, 0, dst, src.Length, bytes.Length);

            HashAlgorithm algorithm = HashAlgorithm.Create("SHA1");
            byte[] inArray = algorithm.ComputeHash(dst);
            return Convert.ToBase64String(inArray);
        }


        public override Model.User Insert(UserInsertRequest request)
        {

            if (request != null)
            {

                if (Context.Users.Where(a => a.Email == request.Email).Any())
                {
                    throw new UserException("User with that username already exists!");
                }
                if (request.Password != request.PasswordConfirmation)
                {
                    throw new UserException("The two password fields didn't match");
                }

                var newUser = IMapper.Map<User>(request);

                newUser.PasswordSalt = GenerateSalt();

                newUser.PasswordHash = GenerateHash(newUser.PasswordSalt, request.Password);

                Context.Users.Add(newUser);
                Context.SaveChanges();

                AfterInsert(request, newUser);

                return IMapper.Map<Model.User>(newUser);
            }
            return null;
        }

        public Model.User Login(string username, string password)
        {
            var entity = Context.Users.Include("UserLanguages").FirstOrDefault(x => x.Email == username);

            if (entity == null)
            {
                throw new UserException("Not valid credentials!");
            }

            var hash = GenerateHash(entity.PasswordSalt, password);

            if (hash != entity.PasswordHash)
            {
                throw new UserException("Not valid credentials!");
            }

            return IMapper.Map<Model.User>(entity);
        }

        public string GenerateToken(Model.User user)
        {
            return jWTService.GenerateToken(user);
        }

        public override void AfterInsert(UserInsertRequest request, User entity)
        {
            if (request.PrimaryLanguageId > 0)
            {
                var userLangPrimary = new Database.UserLanguage
                {
                    UserId = entity.Id,
                    LanguageId = request.PrimaryLanguageId,
                    Type = "Primary"
                };
                Context.UserLanguages.Add(userLangPrimary);
            }

            if (request.SecondaryLanguageId > 0)
            {
                var userLangSecondary = new Database.UserLanguage
                {
                    UserId = entity.Id,
                    LanguageId = request.SecondaryLanguageId,
                    Type = "Secondary"
                };
                Context.UserLanguages.Add(userLangSecondary);
            }

            Context.SaveChanges();
        }

        public virtual Model.User Update(int id, UserUpdateRequest request)
        {
            var set = Context.Set<User>();

            var entity = Context.Users
             .Include(u => u.UserLanguages)
             .FirstOrDefault(u => u.Id == id);

            BeforeUpdate(entity, request);
            AfterUpdate(entity, request);

            if (entity != null)
            {
                IMapper.Map(request, entity);
            }
            else
            {
                return null;
            }

            Context.SaveChanges();

            return IMapper.Map<Model.User>(entity);
        }

        public override void AfterUpdate(User entity, UserUpdateRequest request)
        {
            var primary = entity.UserLanguages.FirstOrDefault(x => x.Type == "Primary");
            if (primary != null)
                Context.UserLanguages.Remove(primary);

            var secondary = entity.UserLanguages.FirstOrDefault(x => x.Type == "Secondary");
            if (secondary != null)
                Context.UserLanguages.Remove(secondary);

            Context.SaveChanges();

            if (request.PrimaryLanguageId > 0)
            {
                var newPrimary = new Database.UserLanguage
                {
                    UserId = entity.Id,
                    LanguageId = request.PrimaryLanguageId,
                    Type = "Primary"
                };
                entity.UserLanguages.Add(newPrimary);
            }

            if (request.SecondaryLanguageId > 0)
            {
                var newSecondary = new Database.UserLanguage
                {
                    UserId = entity.Id,
                    LanguageId = request.SecondaryLanguageId,
                    Type = "Secondary"
                };
                entity.UserLanguages.Add(newSecondary);
            }

            Context.SaveChanges();
        }

        public override IQueryable<User> AddInclude(IQueryable<User> query, UserSearchObject searchObject = null)
        {
            var includedQuery = base.AddInclude(query, searchObject);

            if (searchObject.IncludeUserLanguage)
            {
                includedQuery = includedQuery.Include("UserLanguages");
            }
            return includedQuery;
        }
    }
}