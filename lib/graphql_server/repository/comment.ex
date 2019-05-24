defmodule GraphqlServer.Repository.Comment do
  alias GraphqlServer.Repository.{Author, Post}

  use Ecto.Schema

  @primary_key {:id, :id, autogenerate: true}
  schema "comments" do
    field :content, :string
    belongs_to :author, Author,
      foreign_key: :author_id, references: :id
    belongs_to :post, Post,
      foreign_key: :post_id, references: :id
  end
end
