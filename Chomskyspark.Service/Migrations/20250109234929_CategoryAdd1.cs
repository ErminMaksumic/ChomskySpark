using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Chomskyspark.Services.Migrations
{
    public partial class CategoryAdd1 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // Create the 'Category' table with 'Id' as the primary key and 'Name' column
            migrationBuilder.CreateTable(
                name: "Categories",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),  // Set 'Id' as auto-incrementing primary key
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: true)  // 'Name' column
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Categories", x => x.Id);  // Set 'Id' as the primary key
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            // Drop the 'Categories' table during rollback
            migrationBuilder.DropTable(
                name: "Categories");
        }
    }
}