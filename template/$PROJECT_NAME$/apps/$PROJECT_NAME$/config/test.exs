use Mix.Config
<%= if assigns[:ecto] == "postgres" do %>
# Configure your database
config :<%= @project_name %>, <%= @project_name_camel_case %>.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "<%= @project_name %>_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
<% end %>

<%= if assigns[:email] do %>
# Configure mailer for test mode
config :<%= @project_name %>, <%= @project_name_camel_case %>.Mailer,
  adapter: Swoosh.Adapters.Test
<% end %>

<%= if assigns[:accounts] do %>
# Configure reset password URL
config :<%= @project_name %>,
  reset_password_url: "http://localhost:4001/reset-password"
<% end %>