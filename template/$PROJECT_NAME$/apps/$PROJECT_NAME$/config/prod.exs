use Mix.Config
<%= if assigns[:ecto] == "postgres" do %>
# Configure your database
config :<%= @project_name %>, <%= @project_name_camel_case %>.Repo,
  adapter: Ecto.Adapters.Postgres
<% end %>

<%= if assigns[:email] do %>
# TODO: Configure your mailer for production, using one of the adapters
# documented here: https://github.com/swoosh/swoosh#adapters
#
# config :<%= @project_name %>, <%= @project_name_camel_case %>.Notifications.Email.Mailer,
#   adapter: Swoosh.Adapters.Sendgrid,
#   api_key: {:system, "SENDGRID_API_KEY"}
<% end %>

<%= if assigns[:accounts] do %>
# Configure authentication-related settings
config :<%= @project_name %>,
  # TODO: Update this to reflect your production DNS domain
  reset_password_url: "http://example.com/reset-password",
  # TODO: Set this environment variable on your production environment
  token_secret: {:system, "TOKEN_SECRET"}
<% end %>

<%= if assigns[:error_reporting] == "honeybadger" do %>
config :honeybadger,
  api_key: System.get_env("HONEYBADGER_API_KEY"),
  environment_name: System.get_env("HONEYBADGER_ENV") || "prod"
<% end %>