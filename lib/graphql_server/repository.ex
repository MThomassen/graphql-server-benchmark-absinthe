defmodule GraphqlServer.Repository do
  use Ecto.Repo,
    otp_app: :graphql_server,
    adapter: Ecto.Adapters.Postgres
end
