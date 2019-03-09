defmodule <%= @project_name_camel_case %>Web.Endpoint do
  @moduledoc """
  The `Phoenix.Endpoint` for `<%= @project_name_camel_case %>Web`.
  """

  use Phoenix.Endpoint, otp_app: :<%= @project_name %>_web
  <%= if assigns[:websockets] && assigns[:api] == "graphql" do %>
  use Absinthe.Phoenix.Endpoint
  <% end %>


  <%= if assigns[:websockets] do %>
  socket("/socket", <%= @project_name_camel_case %>Web.UserSocket, websocket: true)
  <% end %>

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/", from: :<%= @project_name %>_web, gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  <%= if assigns[:assets] || assigns[:html] || assigns[:gettext] do %>
  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end
  <% end %>

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_<%= @project_name %>_web_key",
    signing_salt: "<%= 8 |> :crypto.strong_rand_bytes() |> Base.encode64() |> binary_part(0, 8) %>"

  plug <%= @project_name_camel_case %>Web.Router

  @doc """
  Callback invoked for dynamically configuring the endpoint.

  It receives the endpoint configuration and checks if
  configuration should be loaded from the system environment.
  """
  def init(_key, config) do
    if config[:load_from_system_env] do
      port = System.get_env("PORT") || raise "expected the PORT environment variable to be set"
      secret_key_base = System.get_env("SECRET_KEY_BASE") || raise "expected the SECRET_KEY_BASE environment variable to be set"

      config =
        config
        |> Keyword.put(:http, [:inet6, port: port])
        |> Keyword.put(:secret_key_base, secret_key_base)

      {:ok, config}
    else
      {:ok, config}
    end
  end
end
