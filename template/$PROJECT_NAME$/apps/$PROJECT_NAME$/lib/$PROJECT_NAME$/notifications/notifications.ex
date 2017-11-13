<% MixTemplates.ignore_file_and_directory_unless(assigns[:email] != nil) %>
defmodule <%= @project_name_camel_case %>.Notifications do
  @moduledoc """
  Sends notifications for `<%= @project_name_camel_case %>`.
  """

  alias <%= @project_name_camel_case %>.Mailer
  alias <%= @project_name_camel_case %>.Notifications.Email
  alias <%= @project_name_camel_case %>.Notifications.Email.Mailer

  <%= if assigns[:accounts] do %>
  @doc """
  Sends a forgot password email to the given email address.

  ## Configuration

      config :<%= @project_name %>,
        reset_password_url: "http://localhost:4000/reset-password"

  The `token` parameter will be appended as a query parameter to the configured
  `:reset_password_url`, like so:

      http://localhost:4000/reset-password?token={token}

  ## Example

      iex> Notifications.forgot_password("test@email.com", "token")
      {:ok, %{...}}
  """
  def forgot_password(email, token) do
    email
    |> Email.forgot_password(token)
    |> Mailer.deliver
  end
  <% else %>
  @doc """
  An example notification function using private modules to send an email.
  """
  def notify_sample(name, email) do
    name
    |> Email.sample(email)
    |> Mailer.deliver
  end
  <% end %>
end
