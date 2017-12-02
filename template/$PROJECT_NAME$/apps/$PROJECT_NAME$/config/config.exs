use Mix.Config

<%= if assigns[:ecto] do %>
config :<%= @project_name %>, ecto_repos: [<%= @project_name_camel_case %>.Repo]
<% end %>

import_config "#{Mix.env}.exs"
