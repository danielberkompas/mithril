<% MixTemplates.ignore_file_and_directory_unless(assigns[:email] != nil) %>
defmodule <%= @project_name_camel_case %>.NotificationsTest do
  use ExUnit.Case

  <%= if assigns[:accounts] do %>
  alias <%= @project_name_camel_case %>.Notifications
  
  describe ".forgot_password/2" do
    test "sends forgot password email" do
      Notifications.forgot_password("test@example.com", "my-token")
      assert_received {:email, email}
      for body <- [email.text_body, email.html_body] do
        assert body =~ Application.get_env(:<%= @project_name %>, :reset_password_url)
        assert body =~ "token=my-token"
      end
    end
  end
  <% else %>
  import Swoosh.TestAssertions

  alias <%= @project_name_camel_case %>.{
    Notifications,
    Notifications.Email
  }

  describe ".notify_sample" do
    test "sends a notification to the given email" do
      Notifications.notify_sample("John Smith", "john@smith.com")
      assert_email_sent Email.sample("John Smith", "john@smith.com")
    end
  end
  <% end %>
end