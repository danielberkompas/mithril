<% MixTemplates.ignore_file_unless(assigns[:accounts] != nil && assigns[:html] != nil) %>
defmodule <%= @project_name_camel_case %>Web.Session do
  @moduledoc """
  Helper module and plug to support storing `<%= @project_name_camel_case %>.Accounts` tokens in the session.
  """

  import Plug.Conn, only: [
    assign: 3, 
    delete_session: 2,
    get_session: 2,
    put_session: 3,
    halt: 1
  ]

  import Phoenix.Controller, only: [
    put_flash: 3,
    redirect: 2
  ]

  alias <%= @project_name_camel_case %>.Accounts
  alias <%= @project_name_camel_case %>Web.Router.Helpers, as: Routes

  @doc """
  Puts a `<%= @project_name_camel_case %>.Accounts` token into the `conn` session and `conn.assigns`.
  """
  @spec put_token(Plug.Conn.t(), Accounts.Token.t()) :: Plug.Conn.t
  def put_token(%Plug.Conn{} = conn, token) do
    conn
    |> put_session(:token, token.token)
    |> assign(:token, token)
  end

  @doc """
  Plug function which loads a token from the `conn`'s session and puts 
  it into the `assigns`.
  """
  @spec load_token(Plug.Conn.t, list) :: Plug.Conn.t
  def load_token(%Plug.Conn{} = conn, _opts) do
    token = get_session(conn, :token)

    case Accounts.get_token(token) do
      {:ok, token} ->
        assign(conn, :token, token)

      _other ->
        conn
    end
  end

  @doc """
  Plug function which requires a token to be present in the session. Use
  this to protect controller actions which can only be accessed by someone
  who is logged in.
  """
  @spec require_token(Plug.Conn.t, list) :: Plug.Conn.t
  def require_token(%Plug.Conn{} = conn, _opts) do
    with %{assigns: %{token: token}} <- load_token(conn, []),
         {:ok, _user} <- Accounts.authenticate(token)
    do
      conn
    else
      _ ->
        conn
        |> delete_token()
        |> redirect_to_login()
    end
  end

  @doc """
  Deletes a `<%= @project_name_camel_case %>.Accounts` token from the `conn` session and assigns.
  """
  @spec delete_token(Plug.Conn.t) :: Plug.Conn.t
  def delete_token(conn) do
    conn
    |> delete_session(:token)
    |> assign(:token, nil)
  end

  defp redirect_to_login(conn) do
    conn
    |> put_flash(:error, "You must log in to access that page.")
    |> redirect(to: Routes.session_path(conn, :new))
    |> halt()
  end
end