defmodule <%= @project_name_camel_case %>API do
  @moduledoc """
  A GraphQL API implemented with `Absinthe` and `AbsinthePlug`. 

  It provides the following modules which can easily integrate with Phoenix or any other
  Plug-based HTTP endpoint.

  - `<%= @project_name_camel_case %>API.Schema`: A pluggable GraphQL schema defining this
    API's GraphQL types, queries, and mutations.
  <%= if assigns[:accounts] do %>

  - `<%= @project_name_camel_case %>API.Context`: A plug which sets up the proper GraphQL
    context on a query, based on the `Authorization` header in the request.
  <% end %>

  - `Absinthe.Plug.GraphiQL`: A GraphiQL plug which can be used to serve GraphiQL at any
    url path of your choosing.

  ## Examples

  It's easy to use `<%= @project_name_camel_case %>API.Schema` with a Phoenix router:

      pipeline :api do
        plug :accepts, ["json"]
        <%= if assigns[:accounts] do %>
        plug <%= @project_name_camel_case %>API.Context
        <% end %>
      end

      scope "/" do
        pipe_through :api

        forward "/api", Absinthe.Plug, schema: <%= @project_name_camel_case %>API.Schema
        forward "/graphiql", Absinthe.Plug.GraphiQL, schema: <%= @project_name_camel_case %>API.Schema
      end

  Also, if `<%= @project_name_camel_case %>API` is set up to load a complex object
  graph, you can query it directly from your web framework using `run/2`.

      {:ok, %{data: %{"some_query" => %{"field" => value}}}} =
        <%= @project_name_camel_case %>API.run(
          \"\"\"
          query some_query($id: ID!) {
            some_query(id: $id) {
              field
            }
          }
          \"\"\",
          variables: %{
            "id" => 123
          }
        )
  """

  @doc """
  Shortcut function to execute a GraphQL query against `<%= @project_name_camel_case %>API.Schema`.

  ## Example

      {:ok, %{data: %{"some_query" => %{"field" => value}}}} =
        <%= @project_name_camel_case %>.run(
          \"\"\"
          query some_query($id: ID!) {
            some_query(id: $id) {
              field
            }
          }
          \"\"\",
          variables: %{
            "id" => 123
          }
        )
  """
  @spec run(String.t(), Absinthe.run_opts()) :: Absinthe.run_result()
  def run(query, opts \\ []) do
    Absinthe.run(query, <%= @project_name_camel_case %>API.Schema, opts)
  end
end
