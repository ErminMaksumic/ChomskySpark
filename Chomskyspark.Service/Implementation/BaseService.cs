using AutoMapper;
using Chomskyspark.Model;
using Chomskyspark.Model.SearchObjects;
using Chomskyspark.Services.Database;
using Chomskyspark.Services.Interfaces;

namespace Chomskyspark.Services.Implementation
{
    public abstract class BaseService<TModel, TSearch, TDbEntity> : IBaseService<TModel, TSearch> where TSearch : BaseSearchObject where TDbEntity : class where TModel : class
    {
        public ChomskySparkContext Context { get; set; }
        public IMapper IMapper { get; set; }
        public BaseService(ChomskySparkContext context, IMapper mapper)
        {
            Context = context;
            IMapper = mapper;
        }

        public virtual IQueryable<TDbEntity> AddFilter(IQueryable<TDbEntity> query, TSearch search = null)
        {
            return query;
        }

        public virtual IQueryable<TDbEntity> AddInclude(IQueryable<TDbEntity> query, TSearch search = null)
        {
            return query;
        }

        public virtual async Task<IEnumerable<TModel>> Get(TSearch search = null)
        {
            var entity = Context.Set<TDbEntity>().AsQueryable();

            entity = AddFilter(entity, search);
            entity = AddInclude(entity, search);

            var list = entity.ToList();
            return IMapper.Map<IList<TModel>>(list);
        }


        public virtual TModel GetById(int id)
        {
            return IMapper.Map<TModel>(Context.Set<TDbEntity>().Find(id));
        }

    }
}
