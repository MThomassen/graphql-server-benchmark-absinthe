defmodule GraphqlServerWeb.Router do
  use GraphqlServerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: GraphqlServerWeb.Schema

    forward "/", Absinthe.Plug,
      schema: GraphqlServerWeb.Schema,
      analyze_complexity: true,
      max_complexity: 50
  end
end
