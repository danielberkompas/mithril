defmodule Mithril do

  @moduledoc File.read!(Path.join([__DIR__, "../README.md"]))
  
  use MixTemplates,
    name: :mithril,
    short_desc: "Template for Elixir umbrella app with convenient scripts.",
    source_dir: "../template",
    options: [
      ecto: [takes: "adapter", default: false],
      elasticsearch: [],
      graphql: [],
      html: []
    ]
end
