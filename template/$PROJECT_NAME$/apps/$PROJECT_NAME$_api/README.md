# <%= @project_name_camel_case %>API

A [GraphQL](http://graphql.org/) API for <%= @project_name_camel_case %>,
built with [Absinthe](http://absinthe-graphql.org).

`<%= @project_name_camel_case %>Web.Router` mounts this GraphQL schema at
`/api` for HTTP requests. You can also query the graph directly:

```elixir
<%= @project_name_camel_case %>API.run("""
query {
  currentUser {
    email
  }
}
""", 
variables: %{}, 
context: %{})
# => {:ok, %{data: %{"createUser" => "..."}}}
```