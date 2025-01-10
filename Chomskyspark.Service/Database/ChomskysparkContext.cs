using Microsoft.Azure.CognitiveServices.Vision.ComputerVision.Models;
using Microsoft.EntityFrameworkCore;

namespace Chomskyspark.Services.Database
{
    public partial class ChomskySparkContext : DbContext
    {
        public ChomskySparkContext()
        { }

        public ChomskySparkContext(DbContextOptions<ChomskySparkContext> options)
            : base(options)
        { }
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                optionsBuilder.UseSqlServer(
                    "Server=.;Database=ChomskySpark;User ID=sqladmin;Password=Azure@2024;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;",
                    options => options.EnableRetryOnFailure()
                );
            }
        }


        public virtual DbSet<LearnedWord> LearnedWords { get; set; }
        public virtual DbSet<ObjectDetectionAttempt> ObjectDetectionAttempts { get; set; }
        public virtual DbSet<User> Users { get; set; }
        public DbSet<Category> Category { get; set; }
    }
}
