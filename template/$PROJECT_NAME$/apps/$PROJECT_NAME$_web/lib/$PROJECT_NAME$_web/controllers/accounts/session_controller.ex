defmodule <%= @project_name_camel_case %>Web.Accounts.SessionController do
  @moduledoc false

  use <%= @project_name_camel_case %>Web, :controller

  alias <%= @project_name_camel_case %>.Accounts
  alias <%= @project_name_camel_case %>Web.Session

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Accounts.tokenize({email, password}) do
      {:ok, token} ->
        conn
        |> Session.put_token(token)
        |> redirect(to: Routes.page_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_status(400)
        |> put_flash(:error, "Invalid email/password combination. Try again?")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> Session.delete_token()
    |> put_flash(:success, "Successfully logged out!")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end