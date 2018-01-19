defmodule <%= @project_name_camel_case %>API.Types.Custom do
  @moduledoc """
  Custom types for <%= @project_name_camel_case %>'s GraphQL API.
  """

  use Absinthe.Schema.Notation

  @desc "An error for a particular input field"
  object :field_error do
    field :type, non_null(:string)
    field :message, non_null(:string)
  end

  @desc "An error encountered while trying to persist input"
  object :input_error do
    field :field, non_null(:string)
    field :errors, list_of(:field_error)
  end
end