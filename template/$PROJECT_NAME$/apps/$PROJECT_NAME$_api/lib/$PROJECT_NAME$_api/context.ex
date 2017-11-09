<% MixTemplates.ignore_file_unless(assigns[:accounts] != nil) %>
defmodule <%= @project_name_camel_case %>API.Context do
  @moduledoc """
  A plug which builds the GraphQL context for <%= @project_name_camel_case %>API.

  If using with Phoenix, you should integrate it into your `:api` pipeline:

      pipeline :api do
        plug :accepts, ["json"]
        plug <%= @project_name_camel_case %>API.Context
      end
  """

  @behaviour Plug
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    context = build_context(conn)
    put_private(conn, :absinthe, %{context: context})
  end

  defp build_context(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] ->
        %{token: token}
      _ ->
        %{}
    end
  end
end