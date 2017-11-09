<% MixTemplates.ignore_file_unless(assigns[:email] != nil) %>
defmodule <%= @project_name_camel_case %>.Mailer do
  @moduledoc """
  Swoosh mailer for sending emails from the domain modules.

  ## Example

      email = <%= @project_name_camel_case %>.Notifications.friend_request(...)
      <%= @project_name_camel_case %>.Mailer.deliver(email)
  """
  use Swoosh.Mailer, otp_app: :<%= @project_name %>
end