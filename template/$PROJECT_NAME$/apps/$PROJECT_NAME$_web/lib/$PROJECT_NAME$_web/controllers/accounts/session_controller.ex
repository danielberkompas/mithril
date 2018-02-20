defmodule <%= @project_name_camel_case %>Web.Accounts.SessionController do
  @moduledoc false

  use <%= @project_name_camel_case %>Web, :controller

  alias <%= @project_name_camel_case %>Web.Session

  action_fallback <%= @project_name_camel_case %>Web.FallbackController

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Session.sign_in(conn, {email, password}) do
      {:ok, conn} ->
        conn
        |> put_flash(:success, Messages.logged_in())
        |> redirect(to: Routes.page_path(conn, :index))
      _error ->
        conn
        |> put_status(400)
        |> put_flash(:error, Messages.invalid_email_or_password())
        |> render("new.html")
      end
  end

  def delete(conn, _params) do
    conn
    |> Session.sign_out()
    |> put_flash(:success, Messages.logged_out())
    |> redirect(to: Routes.page_path(conn, :index))
  end
end