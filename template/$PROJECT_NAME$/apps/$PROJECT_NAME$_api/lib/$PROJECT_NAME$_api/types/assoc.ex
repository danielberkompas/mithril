defmodule <%= @project_name_camel_case %>API.Schema.Assoc do
  @moduledoc """
  Helpers for resolving GraphQL associations without N+1 issues. An alternative
  to `absinthe_ecto`, allowing us to call domain functions instead of Ecto Repos
  to get associations.

  See `assoc/2` for more details.
  """

  import Absinthe.Resolution.Helpers

  @doc """
  Loads a "association" or group of items using a domain function.

  ## Parameters

  - `assoc_type`: Either `:many` or `:one`. Use `:many` for has_many relationships,
    and `:one` for belongs_to and has_one.

  - `field`: The field on the current `object` that will be passed to the 
    domain function. A list of this field's values will be passed.

  - `group_by`: The field on the returned data types which corresponds to 
    the current `object`.

  - `default`: The default value to be returned for the field if no
    associated objects are returned.

  - `resolver_fun`: The domain function to use to resolve the field.

  ## Example

      # Example object schema
      object :post do
        field :id, :integer
        field :title, :string
        field :comments, list_of(:comments), 
          resolve: assoc(:many, {:id, :post_id}, &Blog.Social.get_comments/1)
      end

      # Example domain function
      def get_comments([id | _] = post_ids) when is_integer(id) do
        Comment
        |> where([c], c.post_id in ^post_ids)
        |> Repo.all
      end
  """
  def assoc(assoc_type, {field, group_by}, resolver_fun) do
    fn type, _args, _context ->
      identifier = Map.get(type, field)
      batch {__MODULE__, :by_field, {resolver_fun, group_by}}, identifier, fn results ->
        {:ok, get_result(results, identifier, assoc_type)}
      end
    end
  end

  defp get_result(results, identifier, :many) do
    Map.get(results, identifier) || []
  end

  defp get_result(results, identifier, :one) do
    case Map.get(results, identifier) do
      [] -> 
        nil
      [result | _] -> 
        result
    end
  end

  @doc false
  def by_field({resolver_fun, group_by}, values) do
    results = resolver_fun.(values)
    Enum.group_by(results, &Map.get(&1, group_by))
  end
end
