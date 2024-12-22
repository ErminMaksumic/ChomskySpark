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

        public virtual DbSet<User> Users { get; set; }
    }
}
