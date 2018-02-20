defmodule <%= @project_name_camel_case %>Web.Accounts.RegistrationController do
  @moduledoc false

  use <%= @project_name_camel_case %>Web, :controller

  alias <%= @project_name_camel_case %>.Accounts
  alias <%= @project_name_camel_case %>Web.Session

  plug :scrub_params, "user" when action in [:create, :update]

  action_fallback <%= @project_name_camel_case %>Web.FallbackController

  def new(conn, _params) do
    with {:ok, changeset} <- Accounts.change_user() do
      render conn, "new.html", changeset: changeset
    end
  end

  def create(conn, %{"user" => params}) do
    with {:ok, user} <- Accounts.create_user(params),
         {:ok, conn} <- Session.sign_in(conn, user) do
      conn
      |> put_flash(:success, Messages.user_created())
      |> redirect(to: Routes.page_path(conn, :index))
    else
      {:error, changeset} ->
        conn
        |> put_status(400)
        |> put_flash(:error, Messages.user_not_created())
        |> render("new.html", changeset: changeset)
      error ->
        error
    end
  end

  def edit(conn, _params) do
    with {:ok, changeset} <- Accounts.change_user(conn.assigns.current_user) do
      render conn, "edit.html", changeset: changeset
    end
  end

  def update(conn, %{"user" => params}) do
    with {:ok, user} <- Accounts.update_user(conn.assigns.current_user, params),
         {:ok, changeset} <- Accounts.change_user(user)
    do
      conn
      |> put_flash(:success, Messages.user_changed())
      |> render("edit.html", changeset: changeset)
    else
      {:error, :user, changeset, _changes} ->
        conn
        |> put_flash(:error, Messages.record_not_changed(changeset))
        |> render("edit.html", changeset: changeset)
      _error ->
        {:ok, changeset} = Accounts.change_user(conn.assigns.token)

        conn
        |> put_flash(:error, Messages.record_not_changed())
        |> render("edit.html", changeset: changeset)
    end
  end
end