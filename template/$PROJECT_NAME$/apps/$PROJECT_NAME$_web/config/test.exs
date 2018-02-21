use Mix.Config

config :<%= @project_name %>_web, <%= @project_name_camel_case %>Web.Endpoint,
  http: [port: 4001],
  server: <%= assigns[:integration] != nil %>

<%= if assigns[:integration] == "hound" do %>
config :hound, driver: "chrome_driver"
<% end %>