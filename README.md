GraphQL Server
---

GraphQL Benchmark Server implemented with [`Elixir`](https://elixir-lang.org/)'s frameworks [`Phoenix`](https://phoenixframework.org/) and [`Absinthe`](https://absinthe-graphql.org/)

![GraphQL Schema](schema.png?raw=true "Schema")

### Starting the application (development)
To start the GraphQL Server:

  * Start RDBMS and Author Service with `docker-compose up`
  * Install Hex package manager with `mix local.hex --if-missing`
  * Install Rebar3 (Erlang build tool) with `mix local.rebar --force`
  * Install GraphQL Server dependencies with `mix deps.get`
  * Start GraphQL Server Phoenix endpoint with `mix phx.server`

Now you can visit the [`GraphiQL Web Application`](http://localhost:4000/api/graphiql) from your browser.

### Running 'release'-configured application
```bash
DATABASE_URL=postgres://postgres:postgres@localhost:5432/postgres MIX_ENV=prod mix phx.server
```

### Query example

```bash
GRAPHQL_QUERY_PAYLOAD=$(echo '{
  "query": "query AuthorsPostWithFullComments($authorId: Int) {
              allPosts(authorId: $authorId) {
                title
                content
                comments {
                  content
                  author {
                    firstname
                    lastname
                  }
                }
              }
            }",
  "variables": {
    "authorId": 1
  },
  "operationName": "AuthorsPostWithFullComments"
}' \
| tr -d '\n\r' \
| jq -c '.')

curl \
  -H "Accept: application/json" \
  -H "content-type: application/json" \
  --data "${GRAPHQL_QUERY_PAYLOAD}" \
  "http://localhost:4000/api"
```
