defmodule <%= @project_name_camel_case %>API.Schema do
  @moduledoc """
  A GraphQL schema for <%= @project_name_camel_case %>. For more info see:
  https://hexdocs.pm/absinthe/Absinthe.html
  """

  use Absinthe.Schema

  <%= if assigns[:accounts] do %>
  import_types <%= @project_name_camel_case %>API.Types.Accounts
  <% else %>
  import_types <%= @project_name_camel_case %>API.Types.Sample
  <% end %>

  query do
    description """
    The following queries can be performed against this GraphQL API.
    <%= if assigns[:accounts] do %>

    Many require an authentication token to be passed in the
    `Authorization` header. This will be noted in the docs for each
    query, when relevant.

    See the `login` mutation for how to create these tokens.
    <% end %>
    """

    <%= if assigns[:accounts] do %>
    import_fields :account_queries
    <% else %>
    import_fields :sample_queries
    <% end %>
  end
  <%= if assigns[:accounts] do %>

  mutation do
    description """
    The following mutations can be performed against this GraphQL API.

    Many require an authentication token to be passed in the
    `Authorization` header. This will be noted in the docs for each
    mutation, when relevant.

    See the `login` mutation for how to create these tokens.
    """

    import_fields :account_mutations
  end
  <% end %>

  # Apply the HandleErrors middleware on every query, subscription or mutation
  # so that resolver functions don't have to handle their own errors.
  #
  # This is very similar to `action_fallback` in Phoenix.
  def middleware(middleware, _field, %Absinthe.Type.Object{identifier: identifier})
  when identifier in [:query, :subscription, :mutation] do
    middleware ++ [<%= @project_name_camel_case %>API.Middleware.HandleErrors]
  end
  def middleware(middleware, _field, _object) do
    middleware
  end
end