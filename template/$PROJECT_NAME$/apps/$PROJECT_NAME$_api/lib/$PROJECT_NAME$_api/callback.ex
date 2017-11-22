<% MixTemplates.ignore_file_unless(assigns[:websockets] != nil) %>
defmodule <%= @project_name_camel_case %>API.Callback do
  @moduledoc """
  `<%= @project_name_camel_case %>.Callback` subscriber module for `<%= @project_name_camel_case %>API`.
  Broadcasts Absinthe subscription events when appropriate events occur in the business logic.
  """

  alias Absinthe.Subscription, warn: false

  # Implement callback behaviours
  # @behaviour <%= @project_name_camel_case %>.DomainName.Callback

  # Broadcast Absinthe subscription events using `Absinthe.Subscription.publish/3`
  #
  # def event_occurred(args) do
  #   Subscription.publish(pubsub(), args, subscription_field_name: "topic")
  # end

  @doc false
  def pubsub do
    Application.get_env(:<%= @project_name_camel_case %>_api, :pubsub)
  end
end