defmodule GraphqlServer.Repository.Author do
  alias GraphqlServer.Repository.{Comment, Post}

  use Ecto.Schema

  @primary_key {:id, :id, autogenerate: true}
  schema "authors" do
    field :firstname, :string
    field :lastname, :string
    has_many :posts, Post,
      foreign_key: :author_id, references: :id
    has_many :comments, Comment,
      foreign_key: :author_id, references: :id
  end
end
