use Mix.Config

<%= if assigns[:ecto] == "postgres" do %>
# Configure your database
config :<%= @project_name %>, <%= @project_name_camel_case %>.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "<%= @project_name %>_dev",
  hostname: "localhost",
  pool_size: 10
<% end %>

<%= if assigns[:email] do %>
# Configure mailer for local previews
config :<%= @project_name %>, <%= @project_name_camel_case %>.Notifications.Email.Mailer,
  adapter: Swoosh.Adapters.Local
<% end %>

<%= if assigns[:accounts] do %>
# Configure reset password URL
config :<%= @project_name %>,
  reset_password_url: "http://localhost:4000/reset-password"
<% end %>

<%= if assigns[:error_reporting] == "honeybadger" do %>
config :honeybadger,
  api_key: "DEV", #  # Needed so Honeybadger will compile, even though dev env is ignored
  environment_name: "dev"
<% end %>
