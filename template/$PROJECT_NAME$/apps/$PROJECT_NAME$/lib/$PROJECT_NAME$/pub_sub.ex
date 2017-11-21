<% MixTemplates.ignore_file_unless(assigns[:websockets] != nil) %>
defmodule <%= @project_name_camel_case %>.PubSub do
  use Mithril.PubSub, otp_app: :<%= @project_name %>
end