﻿using Chomskyspark.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace Chomskyspark.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class BaseCRUDController<TModel, TSearch, TInsert, TUpdate> : BaseController<TModel, TSearch>
       where TModel : class where TSearch : class where TInsert : class where TUpdate : class
    {
        public BaseCRUDController(ICRUDService<TModel, TSearch, TInsert, TUpdate> service) : base(service)
        { }


        [HttpPost]
        public virtual TModel Insert([FromBody] TInsert request)
        {
            return ((ICRUDService<TModel, TSearch, TInsert, TUpdate>)IBaseService).Insert(request);
        }

        [HttpPut("{id}")]
        public virtual TModel Update(int id, [FromBody] TUpdate request)
        {
            return ((ICRUDService<TModel, TSearch, TInsert, TUpdate>)IBaseService).Update(id, request);
        }

        [HttpDelete("{id}")]
        public virtual TModel Delete(int id)
        {
            return ((ICRUDService<TModel, TSearch, TInsert, TUpdate>)IBaseService).Delete(id);
        }
    }
}
