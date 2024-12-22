using Chomskyspark.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Chomskyspark.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class BaseController<TModel, TSearch> : ControllerBase where TModel : class where TSearch : class
    {
        public readonly IBaseService<TModel, TSearch> IBaseService;
        public BaseController(IBaseService<TModel, TSearch> service)
        {
            IBaseService = service;
        }
        [HttpGet]
        virtual public async Task<IEnumerable<TModel>> Get([FromQuery] TSearch search)
        {
            return await IBaseService.Get(search);
        }
        [HttpGet("{id}")]

        virtual public TModel GetById(int id)
        {
            return IBaseService.GetById(id);
        }


    }
}
