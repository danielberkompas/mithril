<%= MixTemplates.ignore_file_and_directory_unless(assigns[:html]) %>
defmodule <%= @project_name_camel_case %>Web.ErrorViewTest do
  use <%= @project_name_camel_case %>Web.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.html" do
    assert render_to_string(<%= @project_name_camel_case %>Web.ErrorView, "404.html", []) ==
           "Not Found"
  end

  test "renders 500.html" do
    assert render_to_string(<%= @project_name_camel_case %>Web.ErrorView, "500.html", []) ==
           "Internal Server Error"
  end
end
