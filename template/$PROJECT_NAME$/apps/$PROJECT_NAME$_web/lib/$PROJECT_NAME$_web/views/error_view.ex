defmodule <%= @project_name_camel_case %>Web.ErrorView do
  @moduledoc false

  use <%= @project_name_camel_case %>Web, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  def render("500.html", _assigns) do
    "Internal Server Error"
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def render("404.html", _assigns) do
    "Not Found"
  end

end
