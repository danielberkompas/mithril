defmodule <%= @project_name_camel_case %>.Notifications.Template do
  @moduledoc """
  PRIVATE module which renders notification templates from `templates/`.

  ## Example

      <%= @project_name_camel_case %>.Notifications.Template.render("sample.html", %{name: "John"})
      # => "<p>Hi John!</p>"
  """

  @template_dir "templates"
  @templates "#{@template_dir}/*.eex" |> Path.expand(__DIR__) |> Path.wildcard()

  require EEx

  for template <- @templates do
    @external_resource template

    compiled = EEx.compile_file(template)
    file = 
      template 
      |> Path.basename() 
      |> String.replace(".eex", "")

    def render(unquote(file), assigns) do
      unquote(compiled)
    end
  end
end