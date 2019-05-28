defmodule GraphqlServer.AuthorClient do
  require Logger

  # TODO; Configurable
  @author_svc_url "http://localhost:4001"

  def find(id) do
    Logger.debug("Invoking AuthorService [#{id}]")

    with url <- "#{@author_svc_url}/authors/#{id}",
         headers <- [{"accept", "application/json"}],
         payload <- <<>>,
         opts <- [pool: :default],
         {:ok, 200, _headers, client_ref} <- :hackney.request(:get, url, headers, payload, opts),
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

    @doc """
    Use for Dataloader Schema resolves. This method extracts the (foreign) key value for the Author entity
    from the parent entity

    Example;
      use Absinthe.Schema.Notation
      import Absinthe.Resolution.Helpers, only: [dataloader: 3]

      object :post do
        field :id, non_null(:id)
        field :author, non_null(:author),
          resolve: dataloader(:dataloader_key, &AuthorClient.Loader.resolve/3, [])
      end
    """
    def resolve(%{author_id: author_id} = _parent, args, info) do
      with %Absinthe.Resolution{definition: definition} <- info,
           %Absinthe.Blueprint.Document.Field{source_location: source_location} <- definition do
        # WORKAROUND; add position of the query field to the batch key. Otherise, multiple (recursive) :author entities won't be resolved
        # query {
        #   post(id: 1) {
        #     author {
        #       comments {
        #         author {
        #           firstname
        #         }
        #       }
        #     }
        #   }
        # }
        #
        # TODO; there's probably another way to determine distinct :author fields in the query
        {:author, Map.merge(args, %{author_id: author_id, level: source_location})}
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
