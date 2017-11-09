<%= MixTemplates.ignore_file_and_directory_unless(assigns[:html] != nil) %>
defmodule <%= @project_name_camel_case %>Web.PageController do
  use <%= @project_name_camel_case %>Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end