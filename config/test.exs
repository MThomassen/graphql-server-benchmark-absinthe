use Mix.Config

# Configure your database
config :graphql_server, GraphqlServer.Repository,
  username: "postgres",
  password: "postgres",
  database: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :graphql_server, GraphqlServerWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
