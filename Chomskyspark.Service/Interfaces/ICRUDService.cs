namespace Chomskyspark.Services.Interfaces
{
    public interface ICRUDService<TModel, TSearch, TInsert, TUpdate> : IBaseService<TModel, TSearch>
        where TModel : class where TSearch : class where TInsert : class where TUpdate : class
    {
        TModel Insert(TInsert request);
        TModel Update(int id, TUpdate request);
        TModel Delete(int id);
    }
}
