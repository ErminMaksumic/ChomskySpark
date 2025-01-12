using Chomskyspark.Services.Database;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;

namespace Chomskyspark.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class StatisticsController : ControllerBase
    {
        private readonly ChomskySparkContext _context;

        public StatisticsController(ChomskySparkContext context)
        {
            _context = context;
        }

        
        [HttpGet("user/{userId}")]
        public async Task<IActionResult> GetUserStatistics(int userId)
        {
            var result = await _context.ObjectDetectionAttempts
                .Where(oda => oda.UserId == userId)
                .GroupBy(oda => oda.UserId)
                .Select(group => new
                {
                    UserId = group.Key,
                    TotalAttempts = group.Count(),
                    SuccessfulAttempts = group.Count(oda => oda.Success),
                    AverageElapsedTime = group.Average(oda => oda.ElapsedTimeInSeconds)
                })
                .FirstOrDefaultAsync();

            if (result == null)
            {
                return NotFound($"No data found for user with ID {userId}");
            }

            return Ok(result);
        }

        
        [HttpGet("word/{targetWord}")]
        public async Task<IActionResult> GetWordStatistics(string targetWord)
        {
            var result = await _context.ObjectDetectionAttempts
                .Where(oda => oda.TargetWord == targetWord)
                .GroupBy(oda => oda.TargetWord)
                .Select(group => new
                {
                    TargetWord = group.Key,
                    TotalAttempts = group.Count(),
                    SuccessfulAttempts = group.Count(oda => oda.Success),
                    AverageElapsedTime = group.Average(oda => oda.ElapsedTimeInSeconds),
                    SuccessRate = (group.Count(oda => oda.Success) * 1.0 / group.Count()) * 100
                })
                .FirstOrDefaultAsync();

            if (result == null)
            {
                return NotFound($"No data found for word {targetWord}");
            }

            return Ok(result);
        }
        [HttpGet("statistics/user/{userId}/average-time")]
        public async Task<IActionResult> GetAverageTimeForUser(int userId)
        {
            var result = await _context.ObjectDetectionAttempts
                .Where(oda => oda.UserId == userId)
                .AverageAsync(oda => oda.ElapsedTimeInSeconds);

            return Ok(new { UserId = userId, AverageTimeInSeconds = result });
        }

        
        [HttpGet("users")]
        public async Task<IActionResult> GetAllUsersStatistics()
        {
            var result = await _context.ObjectDetectionAttempts
                .GroupBy(oda => oda.UserId)
                .Select(group => new
                {
                    UserId = group.Key,
                    TotalAttempts = group.Count(),
                    SuccessfulAttempts = group.Count(oda => oda.Success),
                    AverageElapsedTime = group.Average(oda => oda.ElapsedTimeInSeconds)
                })
                .ToListAsync();

            return Ok(result);
        }

     
        [HttpGet("words")]
        public async Task<IActionResult> GetAllWordsStatistics()
        {
            var result = await _context.ObjectDetectionAttempts
                .GroupBy(oda => oda.TargetWord)
                .Select(group => new
                {
                    TargetWord = group.Key,
                    TotalAttempts = group.Count(),
                    SuccessfulAttempts = group.Count(oda => oda.Success),
                    AverageElapsedTime = group.Average(oda => oda.ElapsedTimeInSeconds),
                    SuccessRate = (group.Count(oda => oda.Success) * 1.0 / group.Count()) * 100
                })
                .ToListAsync();

            return Ok(result);
        }

        [HttpGet("word/{targetWord}/date")]
           public async Task<IActionResult> GetWordStatisticsByDate(string targetWord, DateTime? startDate, DateTime? endDate)
        {
            var query = _context.ObjectDetectionAttempts.Where(oda => oda.TargetWord == targetWord);

            if (startDate.HasValue)
                query = query.Where(oda => oda.Timestamp >= startDate);

            if (endDate.HasValue)
                query = query.Where(oda => oda.Timestamp <= endDate);

            var result = await query
                .GroupBy(oda => oda.TargetWord)
                .Select(group => new
                {
                    TargetWord = group.Key,
                    TotalAttempts = group.Count(),
                    SuccessfulAttempts = group.Count(oda => oda.Success),
                    AverageElapsedTime = group.Average(oda => oda.ElapsedTimeInSeconds),
                    SuccessRate = (group.Count(oda => oda.Success) * 1.0 / group.Count()) * 100
                })
                .FirstOrDefaultAsync();

            if (result == null)
            {
                return NotFound($"No data found for word {targetWord}");
            }

            return Ok(result);
        }
        [HttpGet("statistics/user/{userId}/improvement-areas")]
        public async Task<IActionResult> GetImprovementAreasForUser(int userId)
        {
            var result = await _context.ObjectDetectionAttempts
                .Where(oda => oda.UserId == userId && oda.Success == false) 
                .GroupBy(oda => oda.TargetWord)
                .Select(group => new
                {
                    TargetWord = group.Key, 
                    TotalFailedAttempts = group.Count(), 
                    FailedPercentage = (double)group.Count() / _context.ObjectDetectionAttempts.Count(oda => oda.UserId == userId) * 100 
                })
                .OrderByDescending(x => x.TotalFailedAttempts) 
                .Take(10) 
                .ToListAsync();

            if (result == null || !result.Any())
            {
                return NotFound($"No improvement areas found for user with ID {userId}");
            }

            return Ok(result);
        }
        [HttpGet("statistics/user/{userId}/improvement-areas-with-time")]
        public async Task<IActionResult> GetImprovementAreasWithTimeForUser(int userId)
        {
            var result = await _context.ObjectDetectionAttempts
                .Where(oda => oda.UserId == userId && oda.Success == false) 
                .GroupBy(oda => oda.TargetWord) 
                .Select(group => new
                {
                    TargetWord = group.Key, 
                    TotalFailedAttempts = group.Count(), 
                    AverageFailedTime = group.Average(oda => oda.ElapsedTimeInSeconds), 
                    FailedPercentage = (double)group.Count() / _context.ObjectDetectionAttempts.Count(oda => oda.UserId == userId) * 100 
                })
                .OrderByDescending(x => x.TotalFailedAttempts) 
                .Take(10) 
                .ToListAsync();

            if (result == null || !result.Any())
            {
                return NotFound($"No improvement areas found for user with ID {userId}");
            }

            return Ok(result);
        }
        [HttpGet("statistics/user/{userId}/daily")]
        public async Task<IActionResult> GetDailyStatisticsForUser(int userId)
        {
            var result = await _context.ObjectDetectionAttempts
                .Where(oda => oda.UserId == userId)
                .GroupBy(oda => oda.Timestamp.Date) 
                .Select(group => new
                {
                    Date = group.Key, 
                    TotalAttempts = group.Count(),
                    SuccessfulAttempts = group.Count(oda => oda.Success),
                    SuccessRate = (group.Count(oda => oda.Success) * 1.0 / group.Count()) * 100
                })
                .OrderBy(x => x.Date)
                .ToListAsync();

            return Ok(result);
        }
        [HttpGet("statistics/user/{userId}/monthly")]
        public async Task<IActionResult> GetMonthlyStatisticsForUser(int userId)
        {
            var result = await _context.ObjectDetectionAttempts
                .Where(oda => oda.UserId == userId)
                .GroupBy(oda => new { oda.Timestamp.Year, oda.Timestamp.Month }) 
                .Select(group => new
                {
                    Year = group.Key.Year,
                    Month = group.Key.Month, 
                    TotalAttempts = group.Count(), 
                    SuccessfulAttempts = group.Count(oda => oda.Success), 
                    SuccessRate = (group.Count(oda => oda.Success) * 1.0 / group.Count()) * 100 
                })
                .OrderBy(x => x.Year)
                .ThenBy(x => x.Month) 
                .ToListAsync();

            return Ok(result);
        }
        [HttpGet("statistics/user/{userId}/yearly")]
        public async Task<IActionResult> GetYearlyStatisticsForUser(int userId)
        {
            var result = await _context.ObjectDetectionAttempts
                .Where(oda => oda.UserId == userId)
                .GroupBy(oda => oda.Timestamp.Year) 
                .Select(group => new
                {
                    Year = group.Key, 
                    TotalAttempts = group.Count(), 
                    SuccessfulAttempts = group.Count(oda => oda.Success), 
                    SuccessRate = (group.Count(oda => oda.Success) * 1.0 / group.Count()) * 100 
                })
                .OrderBy(x => x.Year) 
                .ToListAsync();

            return Ok(result);
        }
        [HttpGet("user/{userId}/forecast-issues")]
        public async Task<IActionResult> GetForecastForPotentialIssues(int userId)
        {
            var attempts = await _context.ObjectDetectionAttempts
                .Where(oda => oda.UserId == userId)
                .OrderBy(oda => oda.Timestamp)
                .ToListAsync();

            if (attempts == null || !attempts.Any())
            {
                return NotFound($"No data found for user with ID {userId}");
            }

            var dailySuccessRate = attempts
                .GroupBy(oda => oda.Timestamp.Date)
                .Select(group => new
                {
                    Date = group.Key,
                    TotalAttempts = group.Count(),
                    SuccessfulAttempts = group.Count(oda => oda.Success),
                    SuccessRate = (group.Count(oda => oda.Success) * 1.0 / group.Count()) * 100
                })
                .OrderBy(x => x.Date)
                .ToList();
          
            var potentialIssues = dailySuccessRate
                .Where(x => x.SuccessRate < 50) 
                .OrderByDescending(x => x.Date)
                .Take(5) 
                .ToList();

            if (potentialIssues.Any())
            {
                var wordIssues = attempts
                    .GroupBy(oda => oda.TargetWord) 
                    .Select(group => new
                    {
                        Word = group.Key,
                        TotalAttempts = group.Count(),
                        SuccessfulAttempts = group.Count(oda => oda.Success),
                        SuccessRate = (group.Count(oda => oda.Success) * 1.0 / group.Count()) * 100
                    })
                    .Where(x => x.SuccessRate < 50) 
                    .OrderByDescending(x => x.SuccessRate)
                    .ToList();

                return Ok(new
                {
                    UserId = userId,
                    Message = "Potential issues detected based on low success rate.",
                    ProblemDates = potentialIssues,
                    WordIssues = wordIssues 
                });
            }

            return Ok(new
            {
                UserId = userId,
                Message = "No significant issues detected."
            });
        }
        [HttpGet("statistics/categories")]
        public async Task<IActionResult> GetCategoryStatisticsForAllUsers()
        {
            var result = await _context.ObjectDetectionAttempts
                .Join(_context.LearnedWords,
                    oda => oda.TargetWord,
                    lw => lw.Word,
                    (oda, lw) => new
                    {
                        CategoryId = lw.CategoryId,  
                        Success = oda.Success,
                        ElapsedTimeInSeconds = oda.ElapsedTimeInSeconds
                    })
                .GroupBy(oda => oda.CategoryId)
                .Select(group => new
                {
                    CategoryId = group.Key,
                    TotalAttempts = group.Count(),
                    SuccessfulAttempts = group.Count(oda => oda.Success),
                    AverageElapsedTime = group.Average(oda => oda.ElapsedTimeInSeconds),
                    SuccessRate = (group.Count(oda => oda.Success) * 1.0 / group.Count()) * 100
                })
                .ToListAsync();

            if (result == null || !result.Any())
            {
                return NotFound("No data found.");
            }

            return Ok(result);
        }
        [HttpGet("statistics/categories1")]
        public async Task<IActionResult> GetCategoryStatisticsForAllUsers1()
        {
                    var result = await _context.ObjectDetectionAttempts
            .Join(_context.LearnedWords,
                oda => oda.TargetWord,
                lw => lw.Word,
                (oda, lw) => new
                {
                    CategoryId = lw.CategoryId,  
                    Success = oda.Success,
                    ElapsedTimeInSeconds = oda.ElapsedTimeInSeconds
                })
            .Join(_context.Categories, 
                lw => lw.CategoryId,
                c => c.Id,
                (oda, c) => new
                {
                    CategoryId = oda.CategoryId,
                    CategoryName = c.Name,  
                    Success = oda.Success,
                    ElapsedTimeInSeconds = oda.ElapsedTimeInSeconds
                })
            .GroupBy(oda => oda.CategoryId)
            .Select(group => new
            {
                CategoryId = group.Key,
                CategoryName = group.First().CategoryName,  
                TotalAttempts = group.Count(),
                SuccessfulAttempts = group.Count(oda => oda.Success),
                AverageElapsedTime = group.Average(oda => oda.ElapsedTimeInSeconds),
                SuccessRate = (group.Count(oda => oda.Success) * 1.0 / group.Count()) * 100
            })
            .ToListAsync();
            if (result == null || !result.Any())
            {
                return NotFound("No data found.");
            }

            return Ok(result);
        }
        [HttpGet("statistics/user/{userId}/daily-progress")]
        public async Task<IActionResult> GetDailyProgressForUser(int userId)
        {
            var result = await _context.ObjectDetectionAttempts
                .Where(oda => oda.UserId == userId)
                .Join(_context.LearnedWords.Include(lw => lw.Category),
                    oda => oda.TargetWord,
                    lw => lw.Word,
                    (oda, lw) => new
                    {
                        Date = oda.Timestamp.Date, 
                        CategoryId = lw.CategoryId,
                        CategoryName = lw.Category.Name,
                        Success = oda.Success,
                        ElapsedTimeInSeconds = oda.ElapsedTimeInSeconds
                    })
                .GroupBy(oda => new { oda.Date, oda.CategoryId })
                .Select(group => new
                {
                    Date = group.Key.Date,
                    CategoryName = group.First().CategoryName,
                    TotalAttempts = group.Count(),
                    SuccessfulAttempts = group.Count(oda => oda.Success),
                    AverageElapsedTime = group.Average(oda => oda.ElapsedTimeInSeconds),
                    SuccessRate = (group.Count(oda => oda.Success) * 1.0 / group.Count()) * 100
                })
                .OrderBy(x => x.Date)
                .ToListAsync();

            if (result == null || !result.Any())
            {
                return NotFound("No data found.");
            }

            return Ok(result);
        }
        [HttpGet("statistics/user/{userId}/daily-progress-by-category")]
        public async Task<IActionResult> GetDailyProgressByCategoryForUser(int userId)
        {
            var result = await _context.LearnedWords
                .Where(lw => lw.UserId == userId)
                .GroupBy(lw => new { lw.CategoryId, lw.DateTime.Date }) 
                .Select(group => new
                {
                    Date = group.Key.Date, 
                    CategoryId = group.Key.CategoryId, 
                    CategoryName = group.First().Category.Name, 
                    NewWordsLearned = group.Count() 
                })
                .OrderBy(x => x.Date)
                .ToListAsync();

            if (result == null || !result.Any())
            {
                return NotFound("No data found.");
            }

            return Ok(result);
        }
        [HttpGet("statistics/user/{userId}/daily-progress/{month}/{year}")]
        public async Task<IActionResult> GetDailyProgressForUserInMonth(int userId, int month, int year)
        {
            try
            {
                var result = await _context.ObjectDetectionAttempts
                    .Where(oda => oda.UserId == userId && oda.Timestamp.Month == month && oda.Timestamp.Year == year) 
                    .Join(_context.LearnedWords.Include(lw => lw.Category),
                        oda => oda.TargetWord,
                        lw => lw.Word,
                        (oda, lw) => new
                        {
                            Date = oda.Timestamp.Date, 
                            CategoryId = lw.CategoryId,
                            CategoryName = lw.Category.Name,
                            Success = oda.Success,
                            ElapsedTimeInSeconds = oda.ElapsedTimeInSeconds
                        })
                    .GroupBy(oda => new { oda.Date, oda.CategoryId })
                    .Select(group => new
                    {
                        Date = group.Key.Date,
                        CategoryName = group.First().CategoryName,
                        TotalAttempts = group.Count(),
                        SuccessfulAttempts = group.Count(oda => oda.Success),
                        AverageElapsedTime = group.Average(oda => oda.ElapsedTimeInSeconds),
                        SuccessRate = (group.Count(oda => oda.Success) * 1.0 / group.Count()) * 100
                    })
                    .OrderBy(x => x.Date) 
                    .ToListAsync();

                if (result == null || !result.Any())
                {
                    return NotFound("No data found.");
                }

                return Ok(result);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }


      
        // najteze kategorije po broju pogadanja objekata iz tih kategorija
        [HttpGet("statistics/hardest-categories")]
        public async Task<IActionResult> GetHardestCategoriesForChild()
        {
            var result = await _context.ObjectDetectionAttempts
                .Join(_context.LearnedWords,
                    oda => oda.TargetWord,
                    lw => lw.Word,
                    (oda, lw) => new
                    {
                        CategoryId = lw.CategoryId,
                        CategoryName = lw.Category.Name,  
                        ElapsedTimeInSeconds = oda.ElapsedTimeInSeconds
                    })
                .GroupBy(oda => new { oda.CategoryId, oda.CategoryName })  
                .Select(group => new
                {
                    CategoryId = group.Key.CategoryId,
                    CategoryName = group.Key.CategoryName,  
                    TotalAttempts = group.Count(),
                    AverageElapsedTime = group.Average(oda => oda.ElapsedTimeInSeconds)
                })
                .OrderByDescending(category => category.TotalAttempts)  
                .Take(5)  
                .ToListAsync();

            if (result == null || !result.Any())
            {
                return NotFound("No data found.");
            }

            return Ok(result);
        }
        
        [HttpGet("statistics/easiest-categories")]
        public async Task<IActionResult> GetEasiestCategoriesForChild()
        {
            var result = await _context.ObjectDetectionAttempts
                .Join(_context.LearnedWords,
                    oda => oda.TargetWord,
                    lw => lw.Word,
                    (oda, lw) => new
                    {
                        CategoryId = lw.CategoryId,
                        CategoryName = lw.Category.Name, 
                        ElapsedTimeInSeconds = oda.ElapsedTimeInSeconds
                    })
                .GroupBy(oda => new { oda.CategoryId, oda.CategoryName })  
                .Select(group => new
                {
                    CategoryId = group.Key.CategoryId,
                    CategoryName = group.Key.CategoryName, 
                    TotalAttempts = group.Count(),
                    AverageElapsedTime = group.Average(oda => oda.ElapsedTimeInSeconds)
                })
                .OrderBy(category => category.TotalAttempts)  
                .Take(5)  
                .ToListAsync();

            if (result == null || !result.Any())
            {
                return NotFound("No data found.");
            }

            return Ok(result);
        }

        // object na kojem je dijete najvise grijesilo
        [HttpGet("statistics/hardest-object")]
        public async Task<IActionResult> GetHardestObjectForChild()
        {
            var result = await _context.ObjectDetectionAttempts
                .Where(oda => !oda.Success)  
                .Join(_context.LearnedWords,
                    oda => oda.TargetWord,
                    lw => lw.Word,
                    (oda, lw) => new
                    {
                        Word = oda.TargetWord,  
                        CategoryName = lw.Category.Name, 
                        ElapsedTimeInSeconds = oda.ElapsedTimeInSeconds  
                    })
                .GroupBy(oda => new { oda.Word, oda.CategoryName })  
                .Select(group => new
                {
                    Word = group.Key.Word,
                    CategoryName = group.Key.CategoryName,
                    TotalFailedAttempts = group.Count(), 
                    AverageElapsedTime = group.Average(oda => oda.ElapsedTimeInSeconds)  
                })
                .OrderByDescending(x => x.TotalFailedAttempts)  
                .FirstOrDefaultAsync();

            if (result == null)
            {
                return NotFound("No problematic object found.");
            }

            return Ok(result);
        }
      


    }

}
