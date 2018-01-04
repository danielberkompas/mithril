defmodule <%= @project_name_camel_case %>Web.Accounts.ResetPasswordController do
  @moduledoc false

  use <%= @project_name_camel_case %>Web, :controller

  alias <%= @project_name_camel_case %>.{
    Accounts,
    Accounts.Token
  }

  plug :validate_token

  def new(conn, _params) do
    {:ok, changeset} = Accounts.change_user()
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"token" => token, "user" => params}) do
    case Accounts.update_user(%Token{token: token}, params) do
      {:ok, _user} ->
        conn
        |> put_flash(:success, "Password changed successfully! Now log in.")
        |> redirect(to: Routes.session_path(conn, :new))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(400)
        |> put_flash(:error, "Password could not be changed!")
        |> render("new.html", changeset: changeset)
      _error ->
        invalid_token(conn)
    end
  end

  defp validate_token(conn, _opts) do
    case Accounts.authenticate(%Token{token: conn.params["token"]}, :recovery) do
      {:ok, _user} ->
        conn
      _error ->
        invalid_token(conn)
    end
  end

  defp invalid_token(conn) do
    conn
    |> put_flash(:error, "That password reset link has expired.")
    |> redirect(to: Routes.page_path(conn, :index))
    |> halt()
  end
end