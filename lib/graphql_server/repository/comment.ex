defmodule GraphqlServer.Repository.Comment do
  alias GraphqlServer.Repository.Post

  use Ecto.Schema

  @primary_key {:id, :id, autogenerate: true}
  schema "comments" do
    field :content, :string
    field :author_id, :integer
    belongs_to :post, Post, foreign_key: :post_id, references: :id
  end
end
