<% MixTemplates.ignore_file_unless(assigns[:html] != nil) %>
defmodule <%= @project_name_camel_case %>Web.PageView do
  @moduledoc false
  
  use <%= @project_name_camel_case %>Web, :view
end
