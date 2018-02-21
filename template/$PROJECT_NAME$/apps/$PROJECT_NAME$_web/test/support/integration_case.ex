<%= MixTemplates.ignore_file_unless(assigns[:integration] == "hound") %>
defmodule <%= @project_name_camel_case %>Web.IntegrationCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require a full, in-browser integration
  test.

  Relies on `<%= @project_name_camel_case %>Web.ConnCase`.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      use <%= @project_name_camel_case %>Web.ConnCase
      use Hound.Helpers

      @moduletag :integration

      hound_session()
    end
  end
end