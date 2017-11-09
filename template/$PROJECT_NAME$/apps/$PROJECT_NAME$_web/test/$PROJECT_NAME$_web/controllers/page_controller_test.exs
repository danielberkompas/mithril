<% MixTemplates.ignore_file_and_directory_unless(assigns[:html] != nil) %>
defmodule <%= @project_name_camel_case %>Web.PageControllerTest do
  use <%= @project_name_camel_case %>Web.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Hello <%= @project_name_camel_case %>"
  end
end