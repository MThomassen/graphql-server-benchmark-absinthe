defmodule GraphqlServer.Repository do
  alias GraphqlServer.Repository
  alias GraphqlServer.Repository.{Comment, Post}

  use Ecto.Repo,
    otp_app: :graphql_server,
    adapter: Ecto.Adapters.Postgres

  import Ecto.Query, only: [from: 2]

  def posts_by_author(author_id) do
    query =
      from p in Post,
        where: p.author_id == ^author_id,
        select: p

    case Repository.all(query) do
      nil -> {:error, "Author not found"}
      posts -> {:ok, posts}
    end
  end

  def comments_by_author(author_id) do
    query =
      from c in Comment,
        where: c.author_id == ^author_id,
        select: c

    case Repository.all(query) do
      nil -> {:error, "Author not found"}
      comments -> {:ok, comments}
    end
  end

  def post_by_id(post_id) do
    case Repository.get(Post, post_id) do
      nil -> {:error, "Post not found"}
      post -> {:ok, post}
    end
  end
end
