using Chomskyspark.Services;
using Chomskyspark.Services.Database;
using Chomskyspark.Helpers.FileManager;
using Chomskyspark.Services.Implementation;
using Chomskyspark.Services.Interfaces;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using System.Text;
using Chomskyspark.Filters;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddTransient<IUserService, UserService>();
builder.Services.AddTransient<IJWTService, JWTService>();
builder.Services.AddTransient<IFileManager, FileManager>();
builder.Services.AddTransient<IObjectDetectionService, ObjectDetectionService>();
builder.Services.AddTransient<ISafetyService, SafetyService>();
builder.Services.AddSingleton<IEmailService, EmailSenderService>();
builder.Services.AddSingleton<EmailSenderService>();
builder.Services.AddTransient<IObjectDetectionAttemptService, ObjectDetectionAttemptService>();
builder.Services.AddTransient<ILanguageService, LanguageService>();
builder.Services.AddTransient<ILearnedWordService, LearnedWordService>();
builder.Services.AddTransient<INotificationService, NotificationService>();
builder.Services.AddControllers(x =>
{
    x.Filters.Add<ExceptionFilter>();
});

builder.Services.AddAutoMapper(typeof(Mapper).Assembly);
builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(opts =>
{
    opts.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        In = ParameterLocation.Header,
        Description = "Bearer token",
        Name = "Authorization",
        Type = SecuritySchemeType.ApiKey,
        Scheme = "Bearer"
    });
    opts.AddSecurityRequirement(new OpenApiSecurityRequirement
{
    {
        new OpenApiSecurityScheme
        {
            Reference = new OpenApiReference
            {
                Type = ReferenceType.SecurityScheme,
                Id = "Bearer"
            },
            Scheme = "Bearer",
            Name = "Bearer",
            In = ParameterLocation.Header,
        },
        new List<string>()
    }
});
});

var connectionString = builder.Configuration.GetConnectionString("ChomskySparkConnection");
builder.Services.AddDbContext<ChomskySparkContext>(options =>
    options.UseSqlServer(connectionString));

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options => {
        options.TokenValidationParameters = new TokenValidationParameters()
        {
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(builder.Configuration.GetSection("CustomData:TokenKey").Value)),
            ValidateIssuer = false,
            ValidateAudience = false,
            ValidateLifetime = false
        };
    });

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();
app.UseStaticFiles();

app.MapControllers();

app.Run();

