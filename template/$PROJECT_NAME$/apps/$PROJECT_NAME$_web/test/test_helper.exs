ExUnit.start()

<%= if assigns[:integration] == "hound" do %>
Application.ensure_all_started(:hound)
<% end %>

<%= if assigns[:ecto] == "postgres" do %>
Ecto.Adapters.SQL.Sandbox.mode(<%= @project_name_camel_case %>.Repo, :manual)
<% end %>