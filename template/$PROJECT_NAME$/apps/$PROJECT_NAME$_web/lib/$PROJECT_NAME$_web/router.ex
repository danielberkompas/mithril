defmodule <%= @project_name_camel_case %>Web.Router do
  @moduledoc "The `Phoenix.Router` for `<%= @project_name_camel_case %>Web`"

  use <%= @project_name_camel_case %>Web, :router
  <%= if assigns[:accounts] && assigns[:html] do %>

  <% end %>
  <%= if assigns[:html] || assigns[:email] do %>

  # This is your site's content security policy. Read more here:
  # https://www.w3.org/TR/CSP2/
  @csp [
    "default-src 'self'",
    "script-src 'self'",
    "style-src 'self' 'unsafe-inline'",
    "form-action 'self'",
    "default-src 'self'"
  ] |> Enum.join(";")

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers, %{"content-security-policy" => @csp}
    <%= if assigns[:accounts] && assigns[:html] do %>
    plug <%= @project_name_camel_case %>Web.Plug.Session,
      fallback: <%= @project_name_camel_case %>Web.FallbackController
    <% end %>
  end
  <% end %>
  <%= if assigns[:accounts] && assigns[:html] do %>

  pipeline :authenticated do
    plug <%= @project_name_camel_case %>Web.Plug.Authenticated,
      fallback: <%= @project_name_camel_case %>Web.FallbackController
  end
  <% end %>
  <%= if assigns[:api] do %>

  pipeline :api do
    plug :accepts, ["json"]
    <%= if assigns[:api] == "graphql" && assigns[:accounts] do %>
    plug <%= @project_name_camel_case %>API.Context
    <% end %>
  end
  <% end %>
  <%= if assigns[:api] == "graphql" do %>

  scope "/" do
    pipe_through :api

    forward "/api", Absinthe.Plug, schema: <%= @project_name_camel_case %>API.Schema
    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: <%= @project_name_camel_case %>API.Schema
  end
  <% end %>
  <%= if assigns[:html] do %>

  scope "/", <%= @project_name_camel_case %>Web do
    pipe_through :browser

    <%= if assigns[:html] do %>
    get "/", PageController, :index
    <% end %>
  end
  <% end %>
  <%= if assigns[:accounts] && assigns[:html] do %>

  scope "/", <%= @project_name_camel_case %>Web.Accounts do
    pipe_through :browser

    get "/register", RegistrationController, :new
    post "/register", RegistrationController, :create

    get "/forgot-password", ForgotPasswordController, :new
    post "/forgot-password", ForgotPasswordController, :create

    get "/reset-password", ResetPasswordController, :new
    post "/reset-password", ResetPasswordController, :create

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    get "/logout", SessionController, :delete
  end

  scope "/", <%= @project_name_camel_case %>Web.Accounts do
    pipe_through [:browser, :authenticated]

    get "/account", RegistrationController, :edit
    put "/account", RegistrationController, :update
  end
  <% end %>
  <%= if assigns[:email] do %>

  if Mix.env == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview, [base_path: "/dev/mailbox"]
    end
  end
  <% end %>
end
