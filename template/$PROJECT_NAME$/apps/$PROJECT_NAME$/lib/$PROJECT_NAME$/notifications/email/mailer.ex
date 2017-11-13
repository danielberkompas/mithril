<% MixTemplates.ignore_file_unless(assigns[:email] != nil) %>
defmodule <%= @project_name_camel_case %>.Email.Mailer do
  @moduledoc """
  Swoosh mailer for sending notification emails.
  """

  use Swoosh.Mailer, otp_app: :<%= @project_name %>
end