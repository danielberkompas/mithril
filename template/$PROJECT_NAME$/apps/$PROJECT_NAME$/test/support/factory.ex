<% MixTemplates.ignore_file_unless(assigns[:ecto] != nil) %>
defmodule <%= @project_name_camel_case %>.Factory do
  @moduledoc """
  Build and insert test data.

  ## Examples

      Factory.build(:user)
      # => %<%= @project_name_camel_case %>.Accounts.User{name: "John Smith"}

      Factory.build(:user, name: "Jane Smith")
      # => %<%= @project_name_camel_case %>.Accounts.User{name: "Jane Smith"}

      Factory.insert!(:user, name: "Jane Smith")
      # => %<%= @project_name_camel_case %>.Accounts.User{name: "Jane Smith"}
  """

  alias <%= @project_name_camel_case %>.Repo
 
  @doc """
  Build a factory struct, with zero side effects.

  Define your factories with build functions, like so:
  
      def build(:user) do
        %<%= @project_name_camel_case %>.Accounts.User{
          attrs here ...
        }
      end
  
  Here's how you build records which have associations:
  
      def build(:user_with_assoc_name) do
        build(:user, assoc_name: build(:assoc_name))
      end

  ## Example

      Factory.build(:user)
      # => %<%= @project_name_camel_case %>.Accounts.User{...}
  """
  def build(_factory_name) do
    # return struct
  end

  @doc """
  Build a factory struct with custom attributes.

  ## Example

  Suppose you had a `build/1` factory for users:

      def build(:user) do
        %<%= @project_name_camel_case %>.Accounts.User{name: "John Smith"}
      end

  You could call `build/2` to customize the name:

      Factory.build(:user, name: "Custom Name")
      # => %<%= @project_name_camel_case %>.Accounts.User{name: "Custom Name"}
  """
  def build(factory_name, attributes) do
    factory_name
    |> build()
    |> struct(attributes)
  end

  @doc """
  Builds and inserts a factory.

  ## Example

  Suppose you had a `build/1` factory for users:

      def build(:user) do
        %<%= @project_name_camel_case %>.Accounts.User{name: "John Smith"}
      end

  You can customize and insert the factory in one call to `insert!/2`:

      Factory.insert!(:user, name: "Custom Name")
      # => <%= @project_name_camel_case %>.Accounts.User{name: "Custom Name"}
  """
  def insert!(factory_name, attributes \\ []) do
    factory_name
    |> build(attributes)
    |> Repo.insert!
  end

  @doc """
  Converts a factory to parameters. Useful for changeset testing.

  ## Example

  Suppose you had a `build/1` factory for users:

      def build(:user) do
        %<%= @project_name_camel_case %>.Accounts.User{name: "John Smith"}
      end

  You can convert that factory to params:

      Factory.params(:user)
      # => %{name: "John Smith"}

      Factory.params(:user, name: "Custom Name")
      # => %{name: "Custom Name"}

      Factory.params(:user, [name: "Custom Name"], stringify_keys: true)
      # => %{"name" => "Custom Name"}
  """
  def params(factory_name, attributes \\ [], opts \\ []) do
    base = build(factory_name, attributes)
    module = base.__struct__

    params =
      base
      |> Map.from_struct
      |> Enum.filter(&field?(&1, module))
      |> Enum.into(%{})
      |> Map.drop([:id, :inserted_at, :updated_at])

    if opts[:stringify_keys] do
      params
      |> Enum.map(&stringify_keys/1)
      |> Enum.into(%{})
    else
      params
    end
  end

  defp field?({key, _val}, module) do
    key in module.__schema__(:fields)
  end

  defp stringify_keys({key, val}), do: {to_string(key), val}
end