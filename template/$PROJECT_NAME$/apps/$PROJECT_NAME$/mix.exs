defmodule <%= @project_name_camel_case %>.Mixfile do
  use Mix.Project

  def project do
    [
      app: :<%= @project_name %>,
      version: "0.0.1",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      docs: docs(),
      lockfile: "../../mix.lock",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
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
      mod: {<%= @project_name_camel_case %>.Application, []},
      extra_applications: [
        :logger,
        :runtime_tools,
        <%= if assigns[:error_reporting] == "honeybadger" do %>
          :honeybadger
        <% end %>
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(:dev),  do: ["lib", "test/support/factory.ex"]
  defp elixirc_paths(_),     do: ["lib"]

  defp docs do
    [
      main: <%= @project_name_camel_case %>
    ]
  end

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [<%= if assigns[:ecto] == "postgres" do %>
      {:postgrex, ">= 0.0.0"}<% end %><%= if assigns[:ecto] do %>,
      {:ecto, "~> 2.2"}<% end %><%= if assigns[:email] do %>,
      {:swoosh, "~> 0.11.0"}<% end %><%= if assigns[:accounts] do %>,
      {:comeonin, "~> 4.0.0"},
      {:bcrypt_elixir, "~> 0.12"},
    <% end %>
    <%= if assigns[:error_reporting] == "honeybadger" do %>
      {:honeybadger, ">= 0.7.0"}
    <% end %>]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [<%= if assigns[:ecto] do %>
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    <% end %>]
  end
end
