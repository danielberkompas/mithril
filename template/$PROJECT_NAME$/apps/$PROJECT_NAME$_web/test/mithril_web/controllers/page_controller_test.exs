defmodule <%= @project_name_camel_case %>Web.PageControllerTest do
  use <%= @project_name_camel_case %>Web.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end
end
