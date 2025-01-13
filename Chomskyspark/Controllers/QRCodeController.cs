using Microsoft.AspNetCore.Mvc;
using ZXing;
using System.Drawing;
using ZXing.Common;

namespace Chomskyspark.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class QRCodeController : ControllerBase
    {
        [HttpGet("generate")]
        public IActionResult GenerateQRCode(string text)
        {
            if (string.IsNullOrWhiteSpace(text))
            {
                return BadRequest("Text cannot be empty.");
            }

            try
            {
                var barcodeWriter = new BarcodeWriterPixelData
                {
                    Format = BarcodeFormat.QR_CODE,
                    Options = new EncodingOptions
                    {
                        Width = 250,  // Širina slike
                        Height = 250, // Visina slike
                        Margin = 1    // Margina
                    }
                };

                var pixelData = barcodeWriter.Write(text);

                using (var bitmap = new Bitmap(pixelData.Width, pixelData.Height))
                {
                    for (int y = 0; y < pixelData.Height; y++)
                    {
                        for (int x = 0; x < pixelData.Width; x++)
                        {
                            var color = pixelData.Pixels[y * pixelData.Width + x] == 0
                                ? Color.White // Bijela za pozadinu
                                : Color.Black; // Crna za kod

                            bitmap.SetPixel(x, y, color);
                        }
                    }

                    using (var stream = new System.IO.MemoryStream())
                    {
                        bitmap.Save(stream, System.Drawing.Imaging.ImageFormat.Png);
                        return File(stream.ToArray(), "image/png");
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }
        [HttpGet("generatebyid")]
        public IActionResult GenerateQRCodeById(int id)
        {
            try
            {
                // Kreiraj BarcodeWriter za QR kod
                var barcodeWriter = new BarcodeWriterPixelData
                {
                    Format = BarcodeFormat.QR_CODE,
                    Options = new EncodingOptions
                    {
                        Width = 250,  // Širina slike
                        Height = 250, // Visina slike
                        Margin = 10    // Povećana margina
                    }
                };

                // Pretvori ID u string pre nego što ga prosledite metodi Write
                var pixelData = barcodeWriter.Write(id.ToString());

                // Kreiraj bitmapu na osnovu podataka o pikselima
                using (var bitmap = new Bitmap(pixelData.Width, pixelData.Height))
                {
                    for (int y = 0; y < pixelData.Height; y++)
                    {
                        for (int x = 0; x < pixelData.Width; x++)
                        {
                            // Pikselske vrednosti su u formatu boje (BGR)
                            var color = pixelData.Pixels[y * pixelData.Width + x] == 0
                                ? Color.White // Bijela za pozadinu
                                : Color.Black; // Crna za kod

                            bitmap.SetPixel(x, y, color);
                        }
                    }

                    // Generisanje slike u memoriji
                    using (var stream = new System.IO.MemoryStream())
                    {
                        bitmap.Save(stream, System.Drawing.Imaging.ImageFormat.Png);
                        return File(stream.ToArray(), "image/png");
                    }
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

    }
}