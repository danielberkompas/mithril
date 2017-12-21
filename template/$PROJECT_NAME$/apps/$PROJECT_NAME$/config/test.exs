use Mix.Config

<%= if assigns[:ecto] == "postgres" do %>
# Configure database for test mode
<%= if assigns[:ci] == "semaphore" do %>
{whoami, _} = System.cmd("whoami", [])
whoami = String.replace(whoami, "\n", "")

config :<%= @project_name %>, <%= @project_name_camel_case %>.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "<%= @project_name %>_test",
  username: System.get_env("DATABASE_POSTGRESQL_USERNAME") || whoami,
  password: System.get_env("DATABASE_POSTGRESQL_PASSWORD") || nil,
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  ownership_timeout: 60_000
<% else %>
config :<%= @project_name %>, <%= @project_name_camel_case %>.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "<%= @project_name %>_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10
<% end %>
<% end %>

<%= if assigns[:email] do %>
# Configure mailer for test mode
config :<%= @project_name %>, <%= @project_name_camel_case %>.Notifications.Email.Mailer,
  adapter: Swoosh.Adapters.Test
<% end %>

<%= if assigns[:accounts] do %>
# Configure reset password URL
config :<%= @project_name %>,
  reset_password_url: "http://localhost:4001/reset-password"
<% end %>

<%= if assigns[:error_reporting] == "honeybadger" do %>
config :honeybadger,
  api_key: "TEST", # Needed so Honeybadger will compile, even though test env is ignored
  environment_name: "test"
<% end %>