defmodule <%= @project_name_camel_case %>API.Factories.Query do
  @moduledoc """
  Factories for generating GraphQL queries for use in tests.
  """

  @queries %{
    current_user: """
    query {
      current_user {
        email
      }
    }
    """
  }

  @doc """
  Returns an executable GraphQL query with the given name.
  """
  @spec query(atom) :: String.t | nil
  def query(name) do
    @queries[name]
  end
end