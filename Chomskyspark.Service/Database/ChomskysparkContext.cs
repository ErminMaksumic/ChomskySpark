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
        public virtual DbSet<Language> Languages { get; set; } = null!;
        public virtual DbSet<UserLanguage> UserLanguages { get; set; } = null!;
        public virtual DbSet<User> Users { get; set; }
        public DbSet<Category> Category { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<UserLanguage>()
                .HasKey(ul => new { ul.UserId, ul.LanguageId });

            modelBuilder.Entity<UserLanguage>()
                .HasOne(ul => ul.User)
                .WithMany(u => u.UserLanguages)
                .HasForeignKey(ul => ul.UserId);

            modelBuilder.Entity<UserLanguage>()
                .HasOne(ul => ul.Language)
                .WithMany(l => l.UserLanguages)
                .HasForeignKey(ul => ul.LanguageId);
        }
    }
}
