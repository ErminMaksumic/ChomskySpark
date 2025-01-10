using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Chomskyspark.Services.Migrations
{
    /// <inheritdoc />
    public partial class RevertAddLanguage : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "LanguageUser");

            migrationBuilder.AddColumn<int>(
                name: "LanguageId",
                table: "Users",
                type: "int",
                nullable: true);

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

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
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

            migrationBuilder.CreateTable(
                name: "LanguageUser",
                columns: table => new
                {
                    LanguagesId = table.Column<int>(type: "int", nullable: false),
                    UsersId = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_LanguageUser", x => new { x.LanguagesId, x.UsersId });
                    table.ForeignKey(
                        name: "FK_LanguageUser_Languages_LanguagesId",
                        column: x => x.LanguagesId,
                        principalTable: "Languages",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_LanguageUser_Users_UsersId",
                        column: x => x.UsersId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_LanguageUser_UsersId",
                table: "LanguageUser",
                column: "UsersId");
        }
    }
}
