defmodule <%= @project_name_camel_case %>API.Factories.Mutation do
  @moduledoc """
  Factories for generating GraphQL queries for use in tests.
  """

  @mutations %{
    create_user: """
    mutation create_user($input: CreateUserInput!) {
      create_user(input: $input) {
        errors {
          field
          errors {
            type
            message
          }
        }
        user {
          email
          inserted_at
          updated_at
        }
      }
    }
    """,
    login: """
    mutation login($input: LoginUserInput!) {
      login(input: $input) {
        token
        user {
          email
        }
      }
    }
    """,
    update_current_user: """
    mutation update_current_user($input: UpdateUserInput!) {
      update_current_user(input: $input) {
        errors {
          field
          errors {
            type
            message
          }
        }
        user {
          email
        }
      }
    }
    """
  }

  @doc """
  Returns an executable GraphQL mutation with the given name.
  """
  @spec mutation(atom) :: String.t | nil
  def mutation(name) do
    @mutations[name]
  end
end