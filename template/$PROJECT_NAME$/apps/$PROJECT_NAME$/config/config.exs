use Mix.Config

<%= if assigns[:ecto] do %>
config :<%= @project_name %>, ecto_repos: [<%= @project_name_camel_case %>.Repo]
<% end %>

<%= if assigns[:error_reporting] == "honeybadger" do %>
config :honeybadger,
  app: :<%= @project_name %>,
  filter_keys: [:password, :password_confirmation, :credit_card],
  use_logger: true
<% end %>


import_config "#{Mix.env}.exs"
