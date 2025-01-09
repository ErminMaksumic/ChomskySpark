using AutoMapper;
using Chomskyspark.Model;
using Chomskyspark.Model.Requests;

namespace Chomskyspark.Services
{
    public class Mapper : Profile
    {
        public Mapper()
        {
            // User
            CreateMap<Database.User, Model.User>().ReverseMap();
            CreateMap<Database.User, UserInsertRequest>().ReverseMap();
            CreateMap<Database.User, UserUpdateRequest>().ReverseMap();

            //ObjectDetectionAttempt
            CreateMap<Database.ObjectDetectionAttempt, Model.ObjectDetectionAttempt>().ReverseMap();
            CreateMap<Database.ObjectDetectionAttempt, ObjectDetectionAttemptUpsertRequest>().ReverseMap();

            // Language
            CreateMap<Database.Language, Language>().ReverseMap();
            CreateMap<Database.UserLanguage, UserLanguage>().ReverseMap();

            CreateMap<Database.User, User>()
         .ForMember(dest => dest.UserLanguages, opt => opt.MapFrom(src => src.UserLanguages));


        }
    }
}