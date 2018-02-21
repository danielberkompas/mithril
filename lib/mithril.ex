defmodule Mithril do
  @moduledoc File.read!(Path.join([__DIR__, "../README.md"]))

  use MixTemplates,
    name: :mithril,
    short_desc: "Template for Elixir umbrella app with convenient scripts.",
    source_dir: "../template",
    options: [
      # Whether to generate basic email/password login functionality.
      accounts: [],

      # Whether to generate an API app for the project, and what type.
      # Supports "graphql"
      # "graphql"
      api: [takes: "type"],

      # Boolean, whether Phoenix should serve assets
      assets: [],

      # What asset bundler to use if Phoenix the --assets option is true
      asset_bundler: [takes: "webpack or brunch", default: "webpack"],

      # Tweaks configuration for a particular continuous integration provider
      ci: [takes: "semaphore or travis"],

      # How are you going to deploy the app?
      # Takes "heroku"
      deploy: [takes: "host"],

      # Boolean: Whether you intend to use Ecto, and if so, which adapter to use.
      # Example: --ecto postgres
      # Takes "postgres"
      ecto: [takes: "adapter"],

      # Boolean: Whether you need to integrate with Elasticsearch for this project.
      # elasticsearch: [],

      # Boolean: Whether this project needs to send email.
      email: [],

      # What error reporting service to use
      error_reporting: [takes: "error reporting service (honeybadger)"],

      # Boolean: Whether this project needs internationalization via Gettext.
      gettext: [],

      # Boolean: Whether this project will serve HTML, and if so, which template
      # language to use.
      #
      # Example: --html slim
      # Takes "slim", "eex"
      html: [takes: "slim or eex"],

      # String, what library to use for in-browser integration testing
      integration: [takes: "hound"],

      # If --assets, which Sass syntax to use:
      #
      # Example: --sass-syntax scss
      # Takes "scss", "sass"
      sass_syntax: [takes: "scss or sass", default: "sass"],

      # Boolean: Whether this project will serve anything over websockets.
      websockets: []
    ]

  def clean_up(context) do
    if Version.match?(context[:elixir_version], "~> 1.6") do
      IO.puts("Running code formatter...")
      System.cmd("mix", ["format"], cd: context[:target_subdir])
    end
  end
end