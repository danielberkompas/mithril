<%= MixTemplates.ignore_file_unless(assigns[:accounts] != nil) %>
defmodule <%= @project_name_camel_case %>Web.Plug.Authenticated do
  @moduledoc """
  Ensures that a user is authenticated.

  You must specify a `:fallback` for errors. See `Phoenix.Controller.action_fallback/1`
  for more details.

  ## Example

      plug <%= @project_name_camel_case %>Web.Plug.Authenticated
        fallback: <%= @project_name_camel_case %>Web.FallbackController
  """

  import Plug.Conn

  alias <%= @project_name_camel_case %>Web.Session

  @doc false
  def init(opts), do: opts

  @doc false
  def call(conn, opts) do
    fallback = Keyword.fetch!(opts, :fallback)

    if Session.signed_in?(conn) do
      conn
    else
      conn
      |> fallback.call({:error, :unauthorized})
      |> halt()
    end
  end
end
