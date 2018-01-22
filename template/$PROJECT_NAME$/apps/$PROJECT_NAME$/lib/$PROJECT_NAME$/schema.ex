<% MixTemplates.ignore_file_unless(assigns[:ecto] != nil) %>
defmodule <%= @project_name_camel_case %>.Schema do
  @moduledoc """
  Define commonly used imports for all `Ecto.Schema`s here.

  ## Example

      defmodule <%= @project_name_camel_case %>.Domain.Schema do
        use <%= @project_name_camel_case %>.Schema
      end
  """

  @doc false
  defmacro __using__(_) do
    quote do
      use Ecto.Schema

      import Ecto.Changeset, warn: false
      import <%= @project_name_camel_case %>.Schema, warn: false
      <%= if assigns[:accounts] do %>
      import Authority.Ecto.Changeset, warn: false
      <% end %>
    end
  end

  # Define any functions you want to be available in all your
  # Ecto.Schemas here
end