namespace Chomskyspark.Services.Interfaces
{
    public interface IBaseService<TModel, TSearch> where TSearch : class
    {
        Task<IEnumerable<TModel>> Get(TSearch search = null);
        public TModel GetById(int id);
    }
}
