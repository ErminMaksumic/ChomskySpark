using AutoMapper;
using Chomskyspark.Model.SearchObjects;
using Chomskyspark.Services.Database;
using Chomskyspark.Services.Interfaces;

namespace Chomskyspark.Services.Implementation
{
    public class CRUDService<TModel, TSearch, TDatabase, TInsert, TUpdate> : BaseService<TModel, TSearch, TDatabase>,
         ICRUDService<TModel, TSearch, TInsert, TUpdate> where TModel : class where TSearch : BaseSearchObject
         where TInsert : class where TDatabase : class where TUpdate : class
    {
        public CRUDService(ChomskySparkContext context, IMapper mapper) : base(context, mapper)
        { }
        public virtual TModel Insert(TInsert request)
        {
            var set = Context.Set<TDatabase>();

            TDatabase entity = IMapper.Map<TDatabase>(request);

            set.Add(entity);

            BeforeInsert(request, entity);
            AfterInsert(request, entity);

            Context.SaveChanges();

            return IMapper.Map<TModel>(entity);
        }

        public virtual TModel Update(int id, TUpdate request)
        {
            var set = Context.Set<TDatabase>();

            var entity = set.Find(id);

            BeforeUpdate(entity, request);
            AfterUpdate(entity, request);

            if (entity != null)
            {
                IMapper.Map(request, entity);
            }
            else
            {
                return null;
            }

            Context.SaveChanges();

            return IMapper.Map<TModel>(entity);
        }

        public virtual TModel Delete(int id)
        {

            var set = Context.Set<TDatabase>();

            var entity = set.Find(id);

            if (entity != null)
            {
                BeforeDelete(entity);
                set.Remove(entity);

                Context.SaveChanges();
            }

            return IMapper.Map<TModel>(entity);
        }

        public virtual void BeforeInsert(TInsert insert, TDatabase entity)
        { }

        public virtual void BeforeDelete(TDatabase entity)
        { }

        public virtual void BeforeUpdate(TDatabase entity, TUpdate request)
        { }
        public virtual void AfterInsert(TInsert request, TDatabase entity)
        { }
        public virtual void AfterUpdate(TDatabase entity, TUpdate request)
        { }

    }
}
