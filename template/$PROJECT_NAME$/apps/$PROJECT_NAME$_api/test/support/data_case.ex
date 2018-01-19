<% MixTemplates.ignore_file_unless(assigns[:ecto] != nil) %>
defmodule <%= @project_name_camel_case %>API.DataCase do
  @moduledoc """
  An ExUnit.CaseTemplate which starts up `<%= @project_name_camel_case %>.Repo` properly
  so that tests can be run which call it.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      import <%= @project_name_camel_case %>API, only: [run: 1, run: 2]
      import <%= @project_name_camel_case %>API.DataCase
      import <%= @project_name_camel_case %>API.Factories.Query
      import <%= @project_name_camel_case %>API.Factories.Mutation
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(<%= @project_name_camel_case %>.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(<%= @project_name_camel_case %>.Repo, {:shared, self()})
    end

    :ok
  end

  @doc """
  Asserts that an invalid token response was returned.

  ## Example

      query
      |> run(...)
      |> assert_invalid_token()
  """
  @spec assert_invalid_token(Absinthe.run_result()) :: no_return
  def assert_invalid_token({:ok, %{data: data, errors: [error | _]}}) do
    assert Enum.all?(data, fn {_key, val} -> is_nil(val) end)
    assert error[:message] =~ "invalid_token"
  end
end