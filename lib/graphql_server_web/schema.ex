defmodule GraphqlServerWeb.Schema do
  alias GraphqlServer.Repository.Loader
  alias GraphqlServerWeb.Schema.Resolver

  use Absinthe.Schema
  import_types GraphqlServerWeb.Schema.Types


  def context(ctx) do
    loader =
      Dataloader.new
      |> Dataloader.add_source(Loader, Loader.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  query do
    @desc "Get post by ID"
    field :post, list_of(:post) do
      arg :id, non_null(:id)
      resolve &Resolver.post_by_id/3
    end

    @desc "Get all Posts by Author"
    field :all_posts, list_of(:post) do
      arg :author_id, non_null(:id)
      resolve &Resolver.posts_by_author/3
    end
  end
end
