using AutoMapper;
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
        }
    }
}