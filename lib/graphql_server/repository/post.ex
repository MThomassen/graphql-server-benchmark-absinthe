defmodule GraphqlServer.Repository.Post do
  alias GraphqlServer.Repository.Comment

  use Ecto.Schema

  @primary_key {:id, :id, autogenerate: true}
  schema "posts" do
    field :title, :string
    field :content, :string
    field :author_id, :integer
    has_many :comments, Comment, foreign_key: :post_id, references: :id
  end
end
