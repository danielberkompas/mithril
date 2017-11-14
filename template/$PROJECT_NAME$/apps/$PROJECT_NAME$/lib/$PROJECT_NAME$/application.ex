defmodule <%= @project_name_camel_case %>.Application do
  @moduledoc """
  The `<%= @project_name_camel_case %>` OTP Application definition. This is where the
  supervision tree for `<%= @project_name_camel_case %>` is defined.
  """

  use Application

  @doc false
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      <%= if assigns[:ecto] do %>
      supervisor(<%= @project_name_camel_case %>.Repo, []),
      <% else %>
      # worker(module, args)
      <% end %>
    ], strategy: :one_for_one, name: <%= @project_name_camel_case %>.Supervisor)
  end
end
