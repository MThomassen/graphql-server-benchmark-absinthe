defmodule GraphqlServer.Repository.Loader do
  def data() do
    Dataloader.Ecto.new(GraphqlServer.Repository, query: &query/2)
  end

  def query(queryable, _params) do
    queryable
  end
end
