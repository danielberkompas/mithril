defmodule <%= @project_name_camel_case %>Web do
  @moduledoc """
  A lightweight Phoenix application, wrapping the logic contained in
  `<%= @project_name_camel_case %>`.

  This module is the entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use <%= @project_name_camel_case %>Web, :controller
      use <%= @project_name_camel_case %>Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  <%= if assigns[:html] do %>
  def controller do
    quote do
      use Phoenix.Controller, namespace: <%= @project_name_camel_case %>Web
      import Plug.Conn
      <%= if assigns[:gettext] do %>import <%= @project_name_camel_case %>Web.Gettext<% end %>
      alias <%= @project_name_camel_case %>Web.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "lib/<%= @project_name %>_web/templates",
                        namespace: <%= @project_name_camel_case %>Web

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import <%= @project_name_camel_case %>Web.ErrorHelpers
      <%= if assigns[:gettext] do %>import <%= @project_name_camel_case %>Web.Gettext<% end %>
      alias <%= @project_name_camel_case %>Web.Router.Helpers, as: Routes
    end
  end
  <% end %>

  def router do
    quote do
      use Phoenix.Router
      <%= if assigns[:error_reporting] == "honeybadger" do %>
        use Honeybadger.Plug
      <% end %>
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  <%= if assigns[:websockets] do %>
  def channel do
    quote do
      use Phoenix.Channel
      <%= if assigns[:gettext] do %>import <%= @project_name_camel_case %>Web.Gettext<% end %>
    end
  end
  <% end %>

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
