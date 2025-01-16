using System.IdentityModel.Tokens.Jwt;

public class AuthMiddleware
{
    private readonly RequestDelegate _next;

    public AuthMiddleware(RequestDelegate next)
    {
        _next = next;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        string authorizationHeader = context.Request.Headers["Authorization"];

        if (!string.IsNullOrEmpty(authorizationHeader) && authorizationHeader.StartsWith("Bearer "))
        {
            var token = authorizationHeader.Substring(7);
            try
            {
                var handler = new JwtSecurityTokenHandler();
                var jwtToken = handler.ReadToken(token) as JwtSecurityToken;

                if (jwtToken != null)
                {
                    var userId = jwtToken.Claims.First(claim => claim.Type == "userId").Value;
                    context.Items["UserId"] = userId;
                }
            }
            catch (Exception)
            {
                context.Response.StatusCode = 401;
                return;
            }
        }

        await _next(context);
    }
}