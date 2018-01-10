defmodule <%= @project_name_camel_case %>Web.Accounts.SessionController do
  @moduledoc false

  use <%= @project_name_camel_case %>Web, :controller

  alias <%= @project_name_camel_case %>.Accounts
  alias <%= @project_name_camel_case %>Web.Session

  action_fallback <%= @project_name_camel_case %>Web.FallbackController

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    with {:ok, token} <- Accounts.tokenize({email, password}) do
      conn
      |> Session.put_token(token)
      |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def delete(conn, _params) do
    conn
    |> Session.delete_token()
    |> put_flash(:success, Messages.logged_out())
    |> redirect(to: Routes.page_path(conn, :index))
  end
end