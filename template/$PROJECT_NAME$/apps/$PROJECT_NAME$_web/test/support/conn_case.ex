defmodule <%= @project_name_camel_case %>Web.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      alias <%= @project_name_camel_case %>Web.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint <%= @project_name_camel_case %>Web.Endpoint
    end
  end

  setup <%= if assigns[:ecto] == "postgres" do %>tags<% else %>_tags<% end %> do
    <%= if assigns[:ecto] == "postgres" do %>:ok = Ecto.Adapters.SQL.Sandbox.checkout(<%= @project_name_camel_case %>.Repo)
    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(<%= @project_name_camel_case %>.Repo, {:shared, self()})
    end
    <% end %>{:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
