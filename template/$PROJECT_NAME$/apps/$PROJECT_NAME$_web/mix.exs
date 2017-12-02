defmodule <%= @project_name_camel_case %>Web.Mixfile do
  use Mix.Project

  def project do
    [
      app: :<%= @project_name %>_web,
      version: "0.0.1",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      docs: docs(),
      lockfile: "../../mix.lock",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix<%= if assigns[:gettext] do %>, :gettext<% end %>] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {<%= @project_name_camel_case %>Web.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  defp docs do
    [
      main: <%= @project_name_camel_case %>Web
    ]
  end

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, github: "phoenixframework/phoenix", override: true},
      {:phoenix_pubsub, "~> 1.0"},<%= if assigns[:ecto] do %>
      {:phoenix_ecto, "~> 3.2"},<% end %><%= if assigns[:html] do %>
      {:phoenix_html, "~> 2.10"},<% end %><%= if assigns[:html] == "slim" do %>
      {:phoenix_slime, "~> 0.8.0"},<% end %>
      {:phoenix_live_reload, "~> 1.0", only: :dev},<%= if assigns[:websockets] && assigns[:api] == "graphql" do %>
      {:absinthe_phoenix, "~> 1.4.0"},<% end %><%= if assigns[:gettext] do %>
      {:gettext, "~> 0.11"},<% end %>
      {:<%= @project_name %>, in_umbrella: true},
      {:cowboy, "~> 1.0"}<%= if assigns[:email] do %>,
      {:swoosh, "~> 0.11.0"} # For mailbox preview plug
    <% end %>]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, we extend the test task to create and migrate the database.
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [<%= if assigns[:ecto] do %>"test": ["ecto.create --quiet", "ecto.migrate", "test"]<% end %>]
  end
end
