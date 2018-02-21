defmodule <%= @project_name_camel_case %>Web.PageTest do
  use <%= @project_name_camel_case %>Web.IntegrationCase

  test "home page loads" do
    navigate_to("/")
    assert page_source() =~ "<%= @project_name_camel_case %>"
  end
end