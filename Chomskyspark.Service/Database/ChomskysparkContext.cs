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
                    "Server=tcp:chomskydbserver.database.windows.net,1433;Database=ChomskySpark;User ID=sqladmin;Password=Azure@2024;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;",
                    options => options.EnableRetryOnFailure()
                );
            }
        }


        public virtual DbSet<User> Users { get; set; }
    }
}
