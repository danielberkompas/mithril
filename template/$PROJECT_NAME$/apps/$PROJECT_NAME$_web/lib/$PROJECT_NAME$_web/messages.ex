defmodule <%= @project_name_camel_case %>Web.Messages do
  @moduledoc """
  Provides user-facing messages.
  """
  <%= if assigns[:gettext] do %>

  import <%= @project_name_camel_case %>Web.Gettext
  <% end %>

  <%= if assigns[:accounts] do %>
  @spec unauthorized :: String.t
  def unauthorized do
    <%= if assigns[:gettext] do %>dgettext("errors", <% end %>"You must be logged in to view that page"<%= if assigns[:gettext] do %>)<% end %>
  end

  @spec password_reset(email :: String.t) :: String.t
  def password_reset(email) do
    <%= if assigns[:gettext] do %>
    dgettext("accounts", "Password reset instructions sent! (If %{email} is a real account)", email: email)
    <% else %>
    "Password reset instructions sent! (If #{email} is a real account)"
    <% end %>
  end

  @spec invalid_email_or_password :: String.t
  def invalid_email_or_password do
    <%= if assigns[:gettext] do %>dgettext("errors", <% end %>"Invalid email/password combination. Try again?"<%= if assigns[:gettext] do %>)<% end %>
  end

  @spec user_created :: String.t
  def user_created do
    <%= if assigns[:gettext] do %>dgettext("errors", <% end %>"Your account has been created!"<%= if assigns[:gettext] do %>)<% end %>
  end

  @spec user_not_created :: String.t
  def user_not_created do
    <%= if assigns[:gettext] do %>dgettext("errors", <% end %>"Could not register! See the errors below"<%= if assigns[:gettext] do %>)<% end %>
  end

  @spec user_changed :: String.t
  def user_changed do
    <%= if assigns[:gettext] do %>dgettext("errors", <% end %>"Account updated!"<%= if assigns[:gettext] do %>)<% end %>
  end

  @spec logged_in :: String.t
  def logged_in do
    <%= if assigns[:gettext] do %>dgettext("errors", <% end %>"Successfully logged in!"<%= if assigns[:gettext] do %>)<% end %>
  end

  @spec logged_out :: String.t
  def logged_out do
    <%= if assigns[:gettext] do %>dgettext("errors", <% end %>"Successfully logged out!"<%= if assigns[:gettext] do %>)<% end %>
  end

  @spec password_reset_link_expired :: String.t
  def password_reset_link_expired do
    <%= if assigns[:gettext] do %>dgettext("errors", <% end %>"That password reset link has expired"<%= if assigns[:gettext] do %>)<% end %>
  end

  @spec user_password_changed :: String.t
  def user_password_changed do
    <%= if assigns[:gettext] do %>dgettext("errors", <% end %>"Password changed successfully!"<%= if assigns[:gettext] do %>)<% end %>
  end

  @spec user_password_not_changed :: String.t
  def user_password_not_changed do
    <%= if assigns[:gettext] do %>dgettext("errors", <% end %>"Password could not be changed!"<%= if assigns[:gettext] do %>)<% end %>
  end

  @spec record_not_changed :: String.t
  def record_not_changed do
    <%= if assigns[:gettext] do %>dgettext("errors", <% end %>"Changes could not be saved. Try again?"<%= if assigns[:gettext] do %>)<% end %>
  end

  @spec record_not_changed(Ecto.Changeset.t) :: String.t
  def record_not_changed(%Ecto.Changeset{} = _changeset) do
    <%= if assigns[:gettext] do %>dgettext("errors", <% end %>"Changes could not be saved. See errors below."<%= if assigns[:gettext] do %>)<% end %>
  end
  <% end %>

  @spec not_found :: String.t
  def not_found do
    <%= if assigns[:gettext] do %>dgettext("errors", <% end %>"Record not found!"<%= if assigns[:gettext] do %>)<% end %>
  end

  @spec unknown_error :: String.t
  def unknown_error do
    <%= if assigns[:gettext] do %>dgettext("errors", <% end %>"An unknown error has occurred"<%= if assigns[:gettext] do %>)<% end %>
  end
end