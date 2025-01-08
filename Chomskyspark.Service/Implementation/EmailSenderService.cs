using Microsoft.Extensions.Configuration;
using MimeKit;

namespace Chomskyspark.Services.Implementation
{
    public class EmailSenderService
    {
        public async Task SendEmail(IConfiguration configuration, string receiverName, string receiverEmail, string subject, string message)
        {
            var email = new MimeMessage();
            email.From.Add(new MailboxAddress(configuration["EmailSettings:Name"],
                configuration["EmailSettings:Email"]));
            email.To.Add(new MailboxAddress(receiverName, receiverEmail));
            email.Subject = subject;
            email.Body = new TextPart("plain")
            {
                Text = message
            };
            using (var client = new MailKit.Net.Smtp.SmtpClient())
            {
                client.Connect(configuration["SmtpSettings:ServerAddress"],
                    int.Parse(configuration["SmtpSettings:Port"]), false);
                client.Authenticate(configuration["EmailSettings:Email"],
                    configuration["EmailSettings:Password"]);
                client.Send(email);
            }
        }
    }
}