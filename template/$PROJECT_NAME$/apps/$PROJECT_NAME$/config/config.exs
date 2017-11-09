use Mix.Config

config :<%= @project_name %>, ecto_repos: [<%= @project_name_camel_case %>.Repo]

import_config "#{Mix.env}.exs"
