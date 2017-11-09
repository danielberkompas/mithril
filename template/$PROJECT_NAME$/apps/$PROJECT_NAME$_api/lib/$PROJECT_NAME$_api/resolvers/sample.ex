<% MixTemplates.ignore_file_unless(assigns[:accounts] == nil) %>
defmodule <%= @project_name_camel_case %>API.Resolvers.Sample do
  @moduledoc """
  A sample GraphQL resolver.
  """

  @samples %{
    "1" => %{name: "John Smith"},
    "2" => %{name: "Jane Smith"}
  }

  # Resolver functions should call into <%= @project_name_camel_case %>'s domain modules
  # to fetch data. Do not use <%= @project_name_camel_case %>.Repo.
  #
  # See `<%= @project_name_camel_case %>API.Batch.batch_on/2`.
  def sample(%{id: id}, %{context: _context}) do
    {:ok, @samples[id]}
  end
end