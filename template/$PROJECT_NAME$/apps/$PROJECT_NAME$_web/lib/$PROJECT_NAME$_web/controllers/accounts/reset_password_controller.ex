defmodule <%= @project_name_camel_case %>Web.Accounts.ResetPasswordController do
  use <%= @project_name_camel_case %>Web, :controller

  alias <%= @project_name_camel_case %>.Accounts

  plug :validate_token

  def new(conn, _params) do
    {:ok, changeset} = Accounts.change_user()
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"token" => token, "user" => params}) do
    case Accounts.update_user(token, params) do
      {:ok, %{user: _user}} ->
        conn
        |> put_flash(:success, "Password changed successfully! Now log in.")
        |> redirect(to: Routes.session_path(conn, :new))
      {:error, :user, changeset, _changes} ->
        conn
        |> put_status(400)
        |> put_flash(:error, "Password could not be changed!")
        |> render("new.html", changeset: changeset)
      {:error, :invalid_token} ->
        invalid_token(conn)
    end
  end

  defp validate_token(conn, _opts) do
    case Accounts.validate_token(conn.params["token"]) do
      :ok ->
        conn
      _other ->
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