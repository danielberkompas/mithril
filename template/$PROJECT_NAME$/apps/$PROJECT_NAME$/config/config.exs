use Mix.Config

<%= if assigns[:ecto] do %>
config :<%= @project_name %>, ecto_repos: [<%= @project_name_camel_case %>.Repo]
<% end %>

<%= if assigns[:websockets] do %>
config :<%= @project_name %>, <%= @project_name_camel_case %>.PubSub,
  adapter: Phoenix.PubSub.PG2,
  pool_size: 10
<% end %>

import_config "#{Mix.env}.exs"
