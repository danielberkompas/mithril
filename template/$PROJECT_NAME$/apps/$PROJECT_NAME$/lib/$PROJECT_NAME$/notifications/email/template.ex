defmodule <%= @project_name_camel_case %>.Notifications.Email.Template do
  @moduledoc """
  PRIVATE module which renders email templates from `templates/`.

  ## Example

      <%= @project_name_camel_case %>.Notifications.Email.Template.render("sample.html", %{name: "John"})
      # => "<p>Hi John!</p>"
  """

  @template_dir "templates"
  @templates "#{@template_dir}/*.eex" |> Path.expand(__DIR__) |> Path.wildcard()

  require EEx

  for template <- @templates do
    # Recompile this module whenever a template file changes
    @external_resource template

    # Convert the template EEX into an Elixir AST
    compiled = EEx.compile_file(template)

    # Convert the full template filepath into a convenient string,
    # such as "template_name.html"
    file = 
      template 
      |> Path.basename() 
      |> String.replace(".eex", "")

    # Defines a render function for each template, taking the filename
    # as the first argument and rendering the EEX within it.
    #
    # A template which looks like this:
    #
    #   # templates/template_name.html.eex
    #   <p>Hello <%%= @name %></p>
    #
    # Will compile to this function definition:
    #
    #   def render("template_name.html", assigns) do
    #     "<p>Hello " <> assigns[:name] <> "</p>"
    #   end
    #
    # This will perform very well at runtime because it's only doing
    # string concatenation.
    def render(unquote(file), assigns) do
      unquote(compiled)
    end
  end
end