defmodule <%= @project_name_camel_case %>Web.FallbackController do
  @moduledoc """
  Provides default error handling for `Phoenix` controllers. Use with
  `Phoenix.Controller.action_fallback/1`.
  """

  use <%= @project_name_camel_case %>Web, :controller
  <%= if assigns[:accounts] do %>

  alias <%= @project_name_camel_case %>Web.Authenticator

  def call(conn, {:error, error}) when error in ~w(invalid_email invalid_password)a do
    conn
    |> put_status(400)
    |> put_flash(:error, Messages.invalid_email_or_password())
    |> render(template_for(conn))
  end

  def call(conn, {:error, error}) when error in ~w(invalid_token token_expired)a do
    conn
    |> put_flash(:error, Messages.unauthorized())
    |> Authenticator.sign_out()
    |> redirect(to: Routes.page_path(conn, :index))
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_flash(:error, Messages.unauthorized())
    |> redirect(to: Routes.page_path(conn, :index))
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(404)
    |> put_flash(:error, Messages.not_found())
    |> render(<%= @project_name_camel_case %>Web.ErrorView, "404.html")
  end
  <% end %>

  @doc false
  def call(conn, _error) do
    conn
    |> put_flash(:error, Messages.unknown_error())
    |> redirect(to: Routes.page_path(conn, :index))
  end
  <%= if assigns[:accounts] do %>

  defp template_for(conn) do
    case action_name(conn) do
      :create -> "new.html"
      :update -> "edit.html"
      action  -> "#{action}.html"
    end
  end
  <% end %>
end