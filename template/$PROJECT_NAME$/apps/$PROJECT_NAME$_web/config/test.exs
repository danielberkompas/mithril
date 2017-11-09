use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :<%= @project_name %>_web, <%= @project_name_camel_case %>Web.Endpoint,
  http: [port: 4001],
  server: false
