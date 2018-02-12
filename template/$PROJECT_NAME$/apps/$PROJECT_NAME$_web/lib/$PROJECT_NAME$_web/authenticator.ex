<%= MixTemplates.ignore_file_unless(assigns[:accounts] != nil) %>
defmodule <%= @project_name_camel_case %>Web.Authenticator do
  @moduledoc false

  use Authenticator
  use Authenticator.Authority,
    token_schema: <%= @project_name_camel_case %>.Accounts.Token,
    tokenization: <%= @project_name_camel_case %>.Accounts,
    authentication: <%= @project_name_camel_case %>.Accounts

  alias <%= @project_name_camel_case %>Web.Router.Helpers, as: Routes
  alias <%= @project_name_camel_case %>Web.Messages

  import Plug.Conn
  import Phoenix.Controller, only: [redirect: 2, put_flash: 3, render: 2]

  @impl true
  def fallback(conn, reason) when reason in [:invalid_email, :invalid_password] do
    conn
    |> put_flash(:error, Messages.invalid_email_or_password())
    |> put_status(400)
    |> render("new.html")
    |> halt()
  end

  @impl true
  def fallback(conn, _reason) do
    conn
    |> put_flash(:error, Messages.unauthorized())
    |> redirect(to: Routes.session_path(conn, :new))
    |> halt()
  end
end
