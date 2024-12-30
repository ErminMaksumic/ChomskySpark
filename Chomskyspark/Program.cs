using Chomskyspark.Services;
using Chomskyspark.Services.Database;
using Chomskyspark.Services.FileManager;
using Chomskyspark.Services.Implementation;
using Chomskyspark.Services.Interfaces;
using eProdaja.API.Filters;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddTransient<IUserService, UserService>();
builder.Services.AddTransient<IJWTService, JWTService>();
builder.Services.AddTransient<IFileManager, FileManager>();
builder.Services.AddTransient<IObjectDetectionService, ObjectDetectionService>();

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
    opts.AddSecurityDefinition("basicAuth", new OpenApiSecurityScheme
    {
        Type = SecuritySchemeType.Http,
        Scheme = "basic"
    });
    opts.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference{Type=ReferenceType.SecurityScheme,Id="basicAuth"}
            },
            new string[]{}
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

