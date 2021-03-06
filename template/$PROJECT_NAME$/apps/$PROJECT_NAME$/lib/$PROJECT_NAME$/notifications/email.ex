defmodule <%= @project_name_camel_case %>.Notifications.Email do
  @moduledoc false

  import Swoosh.Email

  alias <%= @project_name_camel_case %>.Notifications.Email.Template

  <%= if assigns[:accounts] do %>
  @doc """
  Builds a forgot password email.
  """
  @spec forgot_password(String.t, <%= @project_name_camel_case %>.Accounts.user_token) :: Swoosh.Email.t
  def forgot_password(email, token) do
    url = Application.get_env(:<%= @project_name %>, :reset_password_url) <> "?token=#{token}"

    new()
    |> to(email)
    |> from({"<%= @project_name_camel_case %>", "no-reply@<%= @project_name %>.com"})
    |> subject("Reset Your Password")
    |> html_body(Template.render("forgot_password.html", %{url: url}))
    |> text_body(Template.render("forgot_password.text", %{url: url}))
  end
  <% else %>
  @doc """
  A sample email function definition. See `<%= @project_name_camel_case %>.Notifications.notify_sample/2`
  to see how it can be used.
  """
  def sample(name, to_email) do
    new()
    |> to({name, to_email})
    |> from({"<%= @project_name_camel_case %>", "no-reply@<%= @project_name %>.com"})
    |> subject("Sample Notification Email")
    |> html_body(Template.render("sample.html", %{name: name}))
    |> text_body(Template.render("sample.text", %{name: name}))
  end
  <% end %>
end