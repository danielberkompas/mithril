defmodule <%= @project_name_camel_case %>Web.Accounts.ResetPasswordController do
  @moduledoc false

  use <%= @project_name_camel_case %>Web, :controller

  alias <%= @project_name_camel_case %>.{
    Accounts,
    Accounts.Token
  }

  plug :validate_token

  action_fallback <%= @project_name_camel_case %>Web.FallbackController

  def new(conn, _params) do
    with {:ok, changeset} <- Accounts.change_user() do
      render conn, "new.html", changeset: changeset
    end
  end

  def create(conn, %{"token" => token, "user" => params}) do
    case Accounts.update_user(%Token{token: token}, params) do
      {:ok, _user} ->
        conn
        |> put_flash(:success, Messages.user_password_changed())
        |> redirect(to: Routes.session_path(conn, :new))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(400)
        |> put_flash(:error, Messages.user_password_not_changed())
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
    |> put_flash(:error, Messages.password_reset_link_expired())
    |> redirect(to: Routes.page_path(conn, :index))
    |> halt()
  end
end