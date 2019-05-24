defmodule GraphqlServerWeb.Schema.Resolver do
  alias GraphqlServer.Repository
  alias GraphqlServer.Repository.Post

  import Ecto.Query, only: [from: 2]

  def posts_by_author(_parent, %{author_id: authorId}, _resolution) do
    query = from p in Post,
            where: p.author_id == ^authorId,
            select: p

    case Repository.all(query) do
      nil -> {:error, "Author not found"}
      posts -> {:ok, posts}
    end
  end

  def post_by_id(_parent, %{id: postId}, _resolution) do
    case Repository.get(Post, postId) do
      nil -> {:error, "Post not found"}
      post -> {:ok, post}
    end
  end
end
