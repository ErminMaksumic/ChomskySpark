using Microsoft.Extensions.Configuration;

namespace Chomskyspark.Services.Interfaces
{
    public interface IEmailService
    {
         Task SendEmail(IConfiguration configuration, string receiverName, string receiverEmail, string subject, string message);
    }
}
