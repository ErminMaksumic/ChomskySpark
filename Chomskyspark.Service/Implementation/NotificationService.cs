using Chomskyspark.Services.Interfaces;
using Microsoft.Azure.NotificationHubs;
using Microsoft.Extensions.Configuration;

namespace Chomskyspark.Services.Implementation
{
    public class NotificationService : INotificationService
    {
        private readonly NotificationHubClient _hub;
        private readonly string connectionString;
        private readonly string hubName;

        public NotificationService(IConfiguration configuration)
        {
            connectionString = configuration["NotificationHub:ConnectionString"] ?? "";
            hubName = configuration["NotificationHub:HubName"] ?? "";
            _hub = NotificationHubClient.CreateClientFromConnectionString(connectionString, hubName);
        }

        public async Task SendNotificationAsync(string message, string tag)
        {
            var androidNotification = "{\"message\":{\"notification\":{\"body\":\"" + message + "\"}}}";
            await _hub.SendFcmV1NativeNotificationAsync(androidNotification, tag);
        }

        public async Task RegisterDeviceAsync(string fcmToken, string tag)
        {
            var registrationDescription = await _hub.CreateFcmV1NativeRegistrationAsync(fcmToken);
            registrationDescription.Tags = new HashSet<string> { tag };
            await _hub.CreateOrUpdateRegistrationAsync(registrationDescription);
        }
    }
}
