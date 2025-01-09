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

            //LearnedWord
            CreateMap<Database.LearnedWord, LearnedWord>().ReverseMap();
            CreateMap<Database.LearnedWord, LearnedWordUpsertModel>().ReverseMap();
            CreateMap<ObjectDetectionAttemptUpsertRequest, Database.LearnedWord>()
                .ForMember(x => x.Word, opt => opt.MapFrom(x => x.TargetWord))
                .ForMember(x => x.DateTime, opt => opt.MapFrom(x => x.Timestamp))
                .ReverseMap();
        }
    }
}