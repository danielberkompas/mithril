ExUnit.start()

<%= if assigns[:ecto] == "postgres" do %>
Ecto.Adapters.SQL.Sandbox.mode(<%= @project_name_camel_case %>.Repo, :manual)
<% end %>