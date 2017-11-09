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
