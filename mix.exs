defmodule Mithril.Mixfile do
  use Mix.Project

  @name :mithril
  @version "0.1.0"

  @maintainers ["Daniel Berkompas <daniel@infinite.red>"]
  @github "https://github.com/infinitered/#{@name}"

  @description "An architecture in a box for a back-end webserver."

  def project do
    in_production = Mix.env() == :prod

    [
      app: @name,
      description: "Elixir project generator for maintainable applications",
      source_url: "https://github.com/infinitered/mithril",
      version: @version,
      deps: deps(),
      docs: docs(),
      elixir: "~> 1.5",
      package: package(),
      description: @description,
      build_embedded: in_production,
      start_permanent: in_production
    ]
  end

  defp package do
    [
      name: @name,
      files: ["lib", "mix.exs", "README.md", "LICENSE", "template"],
      maintainers: @maintainers,
      licenses: ["MIT"],
      links: %{
        "GitHub" => @github
      }
    ]
  end

  def docs do
    [
      assets: "assets",
      main: "overview",
      extra_section: "GUIDES",
      extras: [
        "guides/introduction/overview.md": [title: "Overview"],
        "guides/introduction/installation.md": [title: "Installation"],
        "guides/introduction/generating.md": [title: "Generating Your Project"],
        "guides/conventions/project_structure.md": [title: "Project Structure"],
        "guides/conventions/domains.md": [title: "Domains"],
        "guides/conventions/client_applications.md": [title: "Client Applications"],
        "guides/conventions/libraries.md": [title: "Libraries"],
        "guides/conventions/why.md": [title: "Why These Conventions?"],
        "guides/how_to/designing_domains.md": [title: "Designing Domains"],
        "guides/how_to/dependent_domains.md": [title: "Dependent Domains"],
        "guides/how_to/authorization.md": [title: "Authorization"],
        "guides/how_to/if_this_then_that.md": [title: "If This Then That"],
        "guides/how_to/internationalization.md": [title: "Internationalization"],
        "guides/how_to/testing.md": [title: "Testing"],
        "guides/anti_patterns/admin_domain.md": [title: "Admin Domain"],
        "guides/anti_patterns/cross_domain_ecto.md": [title: "Cross-Domain Ecto Relationships"],
        "guides/anti_patterns/global_user_module.md": [title: "Global User Module"]
      ],
      groups_for_extras: [
        Introduction: Path.wildcard("guides/introduction/*.md"),
        Conventions: Path.wildcard("guides/conventions/*.md"),
        "How To": Path.wildcard("guides/how_to/*.md"),
        "Anti-Patterns": Path.wildcard("guides/anti_patterns/*.md")
      ]
    ]
  end

  def deps do
    [
      {:mix_templates, "> 0.0.0", app: false},
      {:ex_doc, "> 0.0.0", only: [:dev, :test]}
    ]
  end
end