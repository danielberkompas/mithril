defmodule <%= @project_name_camel_case %>Web.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      supervisor(<%= @project_name_camel_case %>Web.Endpoint, []),
      <%= if assigns[:websockets] && assigns[:api] == "graphql" do %>
      supervisor(Absinthe.Subscription, [<%= @project_name_camel_case %>Web.Endpoint])
      <% end %>
      # Start your own worker by calling: <%= @project_name_camel_case %>Web.Worker.start_link(arg1, arg2, arg3)
      # worker(<%= @project_name_camel_case %>Web.Worker, [arg1, arg2, arg3]),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: <%= @project_name_camel_case %>Web.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    <%= @project_name_camel_case %>Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
