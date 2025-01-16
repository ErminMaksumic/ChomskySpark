
namespace Chomskyspark.Services.Interfaces
{
    public interface INotificationService
    {
        Task SendNotificationAsync(string message, string tag);
        Task RegisterDeviceAsync(string fcmToken, string tag);
    }
}
