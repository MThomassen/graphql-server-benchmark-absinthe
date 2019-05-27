defmodule GraphqlServerWeb.Schema do
  alias GraphqlServer.AuthorClient
  alias GraphqlServer.Repository

  use Absinthe.Schema
  import_types(GraphqlServerWeb.Schema.Types)

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(:repository_loader, Repository.Loader.data())
      |> Dataloader.add_source(:author_service_loader, AuthorClient.Loader.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  query do
    @desc "Get post by ID"
    field :post, list_of(:post) do
      arg(:id, non_null(:id))
      resolve(fn _parent, %{id: id} = _args, _resolution -> Repository.post_by_id(id) end)
    end

    @desc "Get all Posts by Author"
    field :all_posts, list_of(:post) do
      arg(:author_id, non_null(:id))

      resolve(fn _parent, %{author_id: author_id} = _args, _resolution ->
        Repository.posts_by_author(author_id)
      end)
    end
  end
end
