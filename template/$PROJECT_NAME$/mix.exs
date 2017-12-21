defmodule <%= @project_name_camel_case %>.Umbrella.Mixfile do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      docs: docs()
    ]
  end

  defp docs do
    [
      main: <%= @project_name_camel_case %>
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: [:dev, :test]}
    ]
  end
end
