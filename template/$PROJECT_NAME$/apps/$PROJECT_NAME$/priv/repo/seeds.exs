<% MixTemplates.ignore_file_and_directory_unless(assigns[:ecto] == "postgres") %>
# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     <%= @project_name_camel_case %>.Factory.insert!(%<%= @project_name_camel_case %>.SomeSchema{})

alias <%= @project_name_camel_case %>.Factory, warn: false