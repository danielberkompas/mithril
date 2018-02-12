defmodule <%= @project_name_camel_case %>Web.Accounts.SessionController do
  @moduledoc false

  use <%= @project_name_camel_case %>Web, :controller

  alias <%= @project_name_camel_case %>Web.Authenticator

  action_fallback <%= @project_name_camel_case %>Web.FallbackController

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    conn
    |> Authenticator.sign_in({email, password})
    |> redirect()
  end

  def delete(conn, _params) do
    conn
    |> Authenticator.sign_out()
    |> put_flash(:success, Messages.logged_out())
    |> redirect(to: Routes.page_path(conn, :index))
  end

  defp redirect(%{halted: false} = conn) do
    redirect(conn, to: Routes.page_path(conn, :index))
  end

  defp redirect(%{halted: true} = conn) do
    conn
  end
end