using Chomskyspark.Model;

namespace Chomskyspark.Services.Interfaces
{
    public interface IJWTService
    {
        string GenerateToken(User user);
    }
}