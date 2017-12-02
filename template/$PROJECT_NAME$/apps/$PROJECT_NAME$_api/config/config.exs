# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

<%= if assigns[:websockets] do %>
config :<%= @project_name %>_api, pubsub: <%= @project_name_camel_case %>Web.Endpoint
<% end %>
