defmodule <%= @project_name_camel_case %>Web.Accounts.RegistrationController do
  @moduledoc false

  use <%= @project_name_camel_case %>Web, :controller

  alias <%= @project_name_camel_case %>.Accounts
  alias <%= @project_name_camel_case %>Web.Session

  plug :scrub_params, "user" when action in [:create, :update]

  def new(conn, _params) do
    {:ok, changeset} = Accounts.change_user()
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => params}) do
    with {:ok, user} <- Accounts.create_user(params),
         {:ok, token} <- Accounts.tokenize({user.email, params["password"]})
    do
      conn
      |> Session.put_token(token)
      |> put_flash(:success, "Your account has been created!")
      |> redirect(to: Routes.page_path(conn, :index))
    else
      {:error, changeset} ->
        conn
        |> put_status(400)
        |> put_flash(:error, "Could not register! See the errors below.")
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, _params) do
    {:ok, changeset} = Accounts.change_user(conn.assigns.token)
    render conn, "edit.html", changeset: changeset
  end

  def update(conn, %{"user" => params}) do
    with {:ok, user} <- Accounts.update_user(conn.assigns.token, params),
         {:ok, changeset} <- Accounts.change_user(user)
    do
      conn
      |> put_flash(:success, "Account updated!")
      |> render("edit.html", changeset: changeset)
    else
      {:error, :user, changeset, _changes} ->
        conn
        |> put_flash(:error, "Changes could not be saved. See errors below.")
        |> render("edit.html", changeset: changeset)
      _error ->
        {:ok, changeset} = Accounts.change_user(conn.assigns.token)

        conn
        |> put_flash(:error, "Changes could not be saved. Try again?")
        |> render("edit.html", changeset: changeset)
    end
  end
end