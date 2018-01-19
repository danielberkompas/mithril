defmodule <%= @project_name_camel_case %>API.Middleware.HandleErrors do
  @moduledoc """
  `Absinthe.Middleware` which handles error tuples from resolver functions.

  This allows resolver functions to be much simpler, because they do not
  have to handle their own errors. This is very similar to `action_fallback`
  in Phoenix.

  ## Example

      # Resolver function
      def get(%{id: id}, _context) do
        Domain.get_item(id)
      end
  """

  @behaviour Absinthe.Middleware
  <%= if assigns[:ecto] do %>

  defp handle_error(%{__struct__: Ecto.Changeset} = changeset) do
    {:ok, %{errors: transform_errors(changeset)}}
  end
  <% end %>

  defp handle_error(error) do
    {:error, error}
  end
  <%= if assigns[:ecto] do %>

  defp transform_errors(%{__struct__: Ecto.Changeset} = changeset) do
    for {field, errors} <- Ecto.Changeset.traverse_errors(changeset, &format_error/1) do
      %{
        field: field,
        errors: for {message, opts} <- errors do
          %{
            type: opts[:validation] || :unique,
            message: message,
          }
        end
      }
    end
  end

  defp format_error({msg, opts}) do
    msg =
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)

    {msg, opts}
  end  
  <% end %>

  @impl Absinthe.Middleware
  def call(%{errors: errors} = resolution, _opts) do
    results =
      errors
      |> Enum.map(&handle_error/1)
      |> Enum.group_by(&elem(&1, 0))

    errors = Enum.map(results[:error] || [], &unwrap!/1)
    resolution = Map.put(resolution, :errors, errors)

    Enum.reduce(results[:ok] || [], resolution, fn result, resolution ->
      Absinthe.Resolution.put_result(resolution, result)
    end)
  end

  defp unwrap!({_, value}), do: value
end