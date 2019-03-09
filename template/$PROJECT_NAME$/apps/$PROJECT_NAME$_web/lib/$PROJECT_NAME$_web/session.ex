<%= MixTemplates.ignore_file_unless(assigns[:accounts] != nil) %>
defmodule <%= @project_name_camel_case %>Web.Session do
  @moduledoc """
  Helpers for manipulating a user's web session.
  """

  import Plug.Conn

  alias <%= @project_name_camel_case %>.{
    Accounts,
    Accounts.User,
    Accounts.Token
  }

  @doc """
  Signs in a user.

  Stores the current user in `conn.assigns.current_user` and places an
  `<%= @project_name_camel_case %>.Accounts.Token.token` value in the
  `session` using `Plug.Conn.put_session/3`.

  ## Examples

  You can sign in an `<%= @project_name_camel_case %>.Accounts.User` struct:

      {:ok, conn} = Session.sign_in(conn, %User{...})

  Or, you can sign in using credentials:

      {:ok, conn} = Session.sign_in(conn, {"valid@email.com", "password"})
  """
  @spec sign_in(Plug.Conn.t, Accounts.user | Accounts.credential) ::
    {:ok, Plug.Conn.t} |
    Accounts.auth_failure
  def sign_in(conn, user_or_credential) do
    with {:ok, token, user} <- create_token(user_or_credential) do
      conn =
        conn
        |> assign(:current_user, user)
        |> put_session(:token, token.token)

      {:ok, conn}
    end
  end

  def signed_in?(conn) do
    conn.assigns[:current_user] != nil
  end

  @doc """
  Signs out the current user.

  ## Example

      conn = Session.sign_out(conn)
  """
  @spec sign_out(Plug.Conn.t) :: Plug.Conn.t
  def sign_out(conn) do
    conn
    |> assign(:current_user, nil)
    |> put_session(:token, nil)
  end

  defp create_token(%User{} = user) do
    with {:ok, token} <- Accounts.tokenize(user) do
      {:ok, token, user}
    end
  end

  defp create_token(%Token{token: nil}) do
    {:ok, %Token{token: "invalid token"}, nil}
  end

  defp create_token(%Token{token: token}) do
    case Accounts.authenticate(%Token{token: token}) do
      {:ok, user} ->
        {:ok, %Token{token: token}, user}

      {:error, _} ->
        {:ok, %Token{token: token}, nil}
    end
  end

  defp create_token(credential) do
    with {:ok, token} <- Accounts.tokenize(credential),
         {:ok, user} <- Accounts.authenticate(token) do
      {:ok, token, user}
    end
  end
end
