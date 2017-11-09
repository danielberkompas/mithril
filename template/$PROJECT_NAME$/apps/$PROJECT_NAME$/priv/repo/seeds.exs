<% MixTemplates.ignore_file_and_directory_unless(assigns[:ecto]) %>
# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     <%= @project_name_camel_case %>.Repo.insert!(%<%= @project_name_camel_case %>.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
