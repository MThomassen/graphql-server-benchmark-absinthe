defmodule GraphqlServer.Repository.Post do
  alias GraphqlServer.Repository.{Author, Comment}

  use Ecto.Schema

  @primary_key {:id, :id, autogenerate: true}
  schema "posts" do
    field :title, :string
    field :content, :string
    belongs_to :author, Author,
      foreign_key: :author_id, references: :id
    has_many :comments, Comment,
      foreign_key: :post_id, references: :id
  end
end
