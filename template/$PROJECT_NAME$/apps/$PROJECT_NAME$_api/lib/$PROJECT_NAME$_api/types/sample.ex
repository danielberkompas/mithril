<% MixTemplates.ignore_file_unless(assigns[:accounts] == nil) %>
defmodule <%= @project_name_camel_case %>API.Types.Sample do
  @moduledoc """
  Sample type definition file.

  ## Usage

      import_types <%= @project_name_camel_case %>API.Types.Sample

      query do
        import_fields :sample_queries
      end
  """

  alias <%= @project_name_camel_case %>API.Resolvers

  ##
  # Types
  ##

  object :sample do
    field :name, :string
  end

  ##
  # Queries
  ##

  object :sample_queries do
    field :sample, :sample do
      arg :id, :id
      resolve &Resolvers.Sample.sample/2
    end
  end
end