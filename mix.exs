defmodule Mithril.Mixfile do
  use Mix.Project

  @name :mithril
  @version "0.1.0"

  @maintainers ["Daniel Berkompas <daniel@infinite.red>"]
  @github "https://github.com/infinitered/#{@name}"

  @description """
  Generates a simple umbrella app structure with convenient setup scripts.
  """

  def project do
    in_production = Mix.env() == :prod

    [
      app: @name,
      version: @version,
      deps: deps(),
      elixir: "~> 1.4",
      package: package(),
      description: @description,
      build_embedded: in_production,
      start_permanent: in_production
    ]
  end

  defp package do
    [
      name: @name,
      files: ["lib", "mix.exs", "README.md", "LICENSE.md", "template"],
      maintainers: @maintainers,
      licenses: ["MIT"],
      links: %{
        "GitHub" => @github
      }
    ]
  end

  def deps do
    [
      {:mix_templates, "> 0.0.0", app: false},
      {:ex_doc, "> 0.0.0", only: [:dev, :test]}
    ]
  end
end