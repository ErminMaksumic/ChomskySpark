using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Chomskyspark.Services.Migrations
{
    /// <inheritdoc />
    public partial class AddLanguage2 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Users_Languages_LanguageId",
                table: "Users");

            migrationBuilder.DropIndex(
                name: "IX_Users_LanguageId",
                table: "Users");

            migrationBuilder.DropColumn(
                name: "LanguageId",
                table: "Users");

            migrationBuilder.DropColumn(
                name: "Type",
                table: "Languages");

            migrationBuilder.CreateTable(
                name: "UserLanguages",
                columns: table => new
                {
                    UserId = table.Column<int>(type: "int", nullable: false),
                    LanguageId = table.Column<int>(type: "int", nullable: false),
                    Type = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserLanguages", x => new { x.UserId, x.LanguageId });
                    table.ForeignKey(
                        name: "FK_UserLanguages_Languages_LanguageId",
                        column: x => x.LanguageId,
                        principalTable: "Languages",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_UserLanguages_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_UserLanguages_LanguageId",
                table: "UserLanguages",
                column: "LanguageId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "UserLanguages");

            migrationBuilder.AddColumn<int>(
                name: "LanguageId",
                table: "Users",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Type",
                table: "Languages",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.CreateIndex(
                name: "IX_Users_LanguageId",
                table: "Users",
                column: "LanguageId");

            migrationBuilder.AddForeignKey(
                name: "FK_Users_Languages_LanguageId",
                table: "Users",
                column: "LanguageId",
                principalTable: "Languages",
                principalColumn: "Id");
        }
    }
}
