defmodule GraphqlServer.AuthorClient do
  # TODO; Configurable
  @author_svc_url "http://localhost:4001"

  def find(id) do
    with url <- "#{@author_svc_url}/authors/#{id}",
         {:ok, 200, _headers, client_ref} <- :hackney.request(:get, url),
         {:ok, body} <- :hackney.body(client_ref),
         {:ok, author} <- Jason.decode(body, keys: :atoms!) do
      author
    else
      {:ok, 404, _headers, _client_ref} -> nil
      error -> error
    end
  end

  defmodule Loader do
    alias GraphqlServer.AuthorClient

    @moduledoc """
    Absinthe Dataloader
    """

    def data() do
      Dataloader.KV.new(&fetch/2, get_policy: :raise_on_error)
    end

    def resolve(%{author_id: author_id} = _parent, args, info) do
      with %Absinthe.Resolution{definition: definition} <- info,
           %Absinthe.Blueprint.Document.Field{source_location: source_location} <- definition,
           %Absinthe.Blueprint.Document.SourceLocation{line: line, column: column} <-
             source_location do
        # WORKAROUND; add position of the query field to the batch key;
        # TODO; other way to determine distinct :author fields in the query
        {:author, Map.merge(args, %{author_id: author_id, level: "#{line}#{column}"})}
      else
        _ -> {:author, Map.merge(args, %{author_id: author_id})}
      end
    end

    defp fetch({:author, %{author_id: author_id}} = _batch_key, arg_maps) do
      author = AuthorClient.find(author_id)

      Enum.reduce(arg_maps, %{}, fn
        arg, result -> Map.put(result, arg, author)
      end)
    end
  end
end
