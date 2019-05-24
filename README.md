GraphQL Server
---

GraphQL Benchmark Server implemented with [`Elixir's`](https://elixir-lang.org/) framework [`Phoenix`](https://phoenixframework.org/) and [`Absinthe`](https://absinthe-graphql.org/)


![GraphQL and RDBMS Schema](schema.png?raw=true "Schema")

### Starting the application (development)
To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server`

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
