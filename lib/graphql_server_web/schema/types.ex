defmodule GraphqlServerWeb.Schema.Types do
  alias GraphqlServer.Repository.Loader

  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  @desc "Author"
  object :author do
    field :id, non_null(:id)
    field :firstname, :string
    field :lastname, :string
    field :posts, list_of(:post), resolve: dataloader(Loader)
    field :comments, list_of(:comment), resolve: dataloader(Loader)
  end

  @desc "Post"
  object :post do
    field :id, non_null(:id)
    field :title, :string
    field :content, :string
    field :author, non_null(:author), resolve: dataloader(Loader)
    field :comments, list_of(:comment), resolve: dataloader(Loader)
  end

  @desc "Comment"
  object :comment do
    field :id, non_null(:id)
    field :content, :string
    field :author, non_null(:author), resolve: dataloader(Loader)
    field :post, non_null(:post), resolve: dataloader(Loader)
  end
end
