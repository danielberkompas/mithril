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

  alias <%= @project_name_camel_case %>.{
    Accounts,
    Accounts.Token
  }

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, _opts) do
    context = 
      conn
      |> parse_token()
      |> current_user()

    put_private(conn, :absinthe, %{context: context})
  end

  defp parse_token(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] ->
        %{token: %Token{token: token}}
      _ ->
        %{}
    end
  end

  defp current_user(%{token: token} = context) do
    case Accounts.authenticate(token) do
      {:ok, user} ->
        Map.merge(context, %{user: user})
      _error ->
        context
    end
  end
end