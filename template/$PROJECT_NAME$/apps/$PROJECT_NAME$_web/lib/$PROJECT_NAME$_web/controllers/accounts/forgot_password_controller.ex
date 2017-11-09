defmodule <%= @project_name_camel_case %>Web.Accounts.ForgotPasswordController do
  use <%= @project_name_camel_case %>Web, :controller

  alias <%= @project_name_camel_case %>.Accounts

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"user" => %{"email" => email}}) do
    # We don't want to give away whether a user account exists with a
    # given email address via this form, so we always assume success.
    Accounts.forgot_user_password(email)

    conn
    |> put_flash(:success, "Password reset instructions sent! (If #{email} is a real account)")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end