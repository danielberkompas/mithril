# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# General application configuration
config :<%= @project_name %>_web,
<%= if assigns[:ecto] do %>
  ecto_repos: [<%= @project_name_camel_case %>.Repo],
<% end %>
  generators: [context_app: :<%= @project_name %>]

# Configures the endpoint
config :<%= @project_name %>_web, <%= @project_name_camel_case %>Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "<%= 64 |> :crypto.strong_rand_bytes() |> Base.encode64() %>",
  render_errors: [view: <%= @project_name_camel_case %>Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: <%= @project_name_camel_case %>Web.PubSub, adapter: Phoenix.PubSub.PG2]

<%= if assigns[:html] == "slim" do %>
# Configures Slim templates
config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine

config :slime, :keep_lines, true
<% end %>

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
