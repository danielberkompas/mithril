defmodule <%= @project_name_camel_case %>.ErrorReporting do
  @moduledoc """
  Provides error reporting functionality to <%= assigns[:error_reporting] || "the error reporting servicce" %>

  ### Usage

  1. Notify <%= @error_reporting || "the error reporting service" %> of an Error

     ```elixir
     <%= @project_name_camel_case %>.ErrorReporting.notify(error, %{user_email: "johndoe@example.com"})
     ```

  2. Set error Context

  Error context is usually pertinent data such as the current user, the current
  resource(s) being acted upon, and the state of aforementioned action(s).

     ```elixir
     <%= @project_name_camel_case %>.ErrorReporting.context(%{user_email: "johndoe@example.com"})
     ```

  """
  <%= if @error_reporting == "honeybadger" do %>
  require Honeybadger
  <%= end %>

  @doc """
  Function to notify <%= assigns[:error_reporting] || "the error reporting service" %> of an error.

  ## Examples

      # Notify with Context
      <%= @project_name_camel_case %>.ErrorReporting.notify(error, %{user_email: "johndoe@example.com"})

      # Notify with default context
      <%= @project_name_camel_case %>.ErrorReporting.notify(error)

  """
  def notify(error, context \\ %{}) do
    <%= if @error_reporting == "honeybadger" do %>
    Honeybadger.notify(error, context)
    <% else %>
    # TODO: Notify external service of error
    <% end %>
  end

  @doc """
  Function to set context for <%= assigns[:error_reporting] || "the error reporting servicce" %>

  ## Examples

      # Setting current user
      <%= @project_name_camel_case %>.ErrorReporting.context(%{user_email: current_user})

      # Setting error info
      <%= @project_name_camel_case %>.ErrorReporting.context(%{api_error: inspect(error)})

  """
  def context(context) do
    <%= if @error_reporting == "honeybadger" do %>
    Honeybadger.context(context)
    <% else %>
    # TODO: Set the relevant context for the external error logging service
    <% end %>
  end
end