defmodule <%= @project_name_camel_case %>.Application do
  @moduledoc """
  The <%= @project_name_camel_case %> Application.
  """

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      <%= if assigns[:ecto] do %>supervisor(<%= @project_name_camel_case %>.Repo, []),<% else %># worker(module, args)<% end %>
    ], strategy: :one_for_one, name: <%= @project_name_camel_case %>.Supervisor)
  end
end
