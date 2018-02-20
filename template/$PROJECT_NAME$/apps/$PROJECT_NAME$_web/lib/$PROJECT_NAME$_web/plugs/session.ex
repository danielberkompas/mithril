<%= MixTemplates.ignore_file_unless(assigns[:accounts] != nil) %>
defmodule <%= @project_name_camel_case %>Web.Plug.Session do
  @moduledoc """
  Loads the current user's session from the `token` in the browser cookie.
  See also `<%= @project_name_camel_case %>Web.Session`.

  You must specify a `:fallback` for errors. See `Phoenix.Controller.action_fallback/1`
  for more details.

  ## Example

      plug <%= @project_name_camel_case %>Web.Plug.Session,
        fallback: <%= @project_name_camel_case %>Web.FallbackController
  """

  import Plug.Conn

  alias <%= @project_name_camel_case %>Web.Session
  alias <%= @project_name_camel_case %>.Accounts.Token

  @doc false
  def init(opts), do: opts

  @doc false
  def call(conn, opts) do
    fallback = Keyword.fetch!(opts, :fallback)

    with {:ok, token} <- get_session(conn, :token),
         {:ok, conn} <- Session.sign_in(conn, %Token{token: token}) do
      conn
    else
      # If there is no token in the session, do nothing
      nil ->
        conn

      error ->
        conn
        |> fallback.call(error)
        |> halt()
    end
  end
end