# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :<%= @project_name %>_web,
  ecto_repos: [<%= @project_name_camel_case %>.Repo],
  generators: [context_app: :<%= @project_name %>]

# Configures the endpoint
config :<%= @project_name %>_web, <%= @project_name_camel_case %>Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ENPDuAMZ8JQufS1mqH8OFkfOquoe0nfR8FjLfyAUP3V/QfMda/u4zCKMBO4mDwcx",
  render_errors: [view: <%= @project_name_camel_case %>Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: <%= @project_name_camel_case %>Web.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
