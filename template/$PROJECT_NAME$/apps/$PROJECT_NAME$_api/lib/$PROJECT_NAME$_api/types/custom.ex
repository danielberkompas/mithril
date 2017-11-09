defmodule <%= @project_name_camel_case %>API.Types.Custom do
  @moduledoc """
  Custom types for <%= @project_name_camel_case %>'s GraphQL API.
  """

  use Absinthe.Schema.Notation

  @desc "An error encountered while trying to persist input"
  object :input_error do
    field :key, non_null(:string)
    field :message, non_null(:string)
  end
end