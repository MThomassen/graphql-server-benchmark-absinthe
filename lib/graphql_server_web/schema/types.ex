defmodule GraphqlServerWeb.Schema.Types do
  alias GraphqlServer.AuthorClient
  alias GraphqlServer.Repository

  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1, dataloader: 3]

  @desc "Author"
  object :author do
    field :id, non_null(:id)
    field :firstname, :string
    field :lastname, :string

    field :posts, list_of(:post),
      resolve: fn %{id: author_id} = _author, _args, _resolution ->
        Repository.posts_by_author(author_id)
      end

    field :comments, list_of(:comment),
      resolve: fn %{id: author_id} = _author, _args, _resolution ->
        Repository.comments_by_author(author_id)
      end
  end

  @desc "Post"
  object :post do
    field :id, non_null(:id)
    field :title, :string
    field :content, :string

    field :author, non_null(:author),
      resolve: dataloader(:author_service_loader, &AuthorClient.Loader.resolve/3, [])

    field :comments, list_of(:comment), resolve: dataloader(:repository_loader)
  end

  @desc "Comment"
  object :comment do
    field :id, non_null(:id)
    field :content, :string

    field :author, non_null(:author),
      resolve: dataloader(:author_service_loader, &AuthorClient.Loader.resolve/3, [])

    field :post, non_null(:post), resolve: dataloader(:repository_loader)
  end
end
