defmodule <%= @project_name_camel_case %> do
  @moduledoc """
  The core Elixir application for `<%= @project_name_camel_case %>`, containing all the business logic 
  and persistence.

  ## Domains

  `<%= @project_name_camel_case %>` is divided into domains, which can be thought
  of as features or groups of closely related features.

  - Each domain defines a single module with a public API.

  - All other modules within the domain are private and must never be called from outside the domain.

  - Each domain manages its own persistence.

  - Each domain only interacts with other domains through their public API functions.

  `<%= @project_name_camel_case %>` provides the following domains:

  <%= if assigns[:accounts] do %>

  - `<%= @project_name_camel_case %>.Accounts`: Provides user registration, login, and forgot password functionality.
  <% end %>
  <%= if assigns[:email] do %>

  - `<%= @project_name_camel_case %>.Notifications`: Provides user-facing notifications, such as emails.
  <% end %>

  - TODO: list domains here

  ## Supporting Applications

  The `<%= @project_name_camel_case %>` platform also contains supporting applications.

  - `apps/<%= @project_name %>_web` (`<%= @project_name_camel_case %>Web`): A lightweight
    Phoenix application which handles HTTP and Websocket requests.
  <%= if assigns[:api] == "graphql" do %>

  - `apps/<%= @project_name %>_api` (`<%= @project_name_camel_case %>API`): Provides a GraphQL API,
    which is mounted inside the `<%= @project_name %>_web` app's router.
  <% end %>
  """
end
