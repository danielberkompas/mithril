<% MixTemplates.ignore_file_and_directory_unless(assigns[:error_reporting] != nil) %>
defmodule <%= @project_name_camel_case %>.ErrorReportingTest do
  use <%= @project_name_camel_case %>.DataCase

  alias <%= @project_name_camel_case %>.ErrorReporting

  describe ".notify/1" do
    test "does not error" do
     ErrorReporting.notify("error")
    end
  end

  describe ".notify/2" do
    test "does not error" do
     ErrorReporting.notify("error", %{test: "1"})
    end
  end

  describe ".context/1" do
    test "does not error" do
     ErrorReporting.context(test: "1")
    end
  end
end