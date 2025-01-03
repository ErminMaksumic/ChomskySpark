namespace Chomskyspark.Helpers.FileManager
{
    public interface IFileManager
    {
        Task<string> UploadFile(IFormFile file);
        Task<string> UploadThumbnailPhoto(IFormFile file);
    }
}
