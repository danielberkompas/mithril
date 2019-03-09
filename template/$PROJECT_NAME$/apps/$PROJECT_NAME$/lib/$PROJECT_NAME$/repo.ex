<% MixTemplates.ignore_file_unless(assigns[:ecto] != nil) %>
defmodule <%= @project_name_camel_case %>.Repo do
  # This Repo is private to <%= @project_name_camel_case %> and MUST NOT be used
  # outside this application. (Including in tests) Use the public
  # API of the domains instead.

  @moduledoc false

  use Ecto.Repo, otp_app: :<%= @project_name %>, adapter: Ecto.Adapters.Postgres

  @doc """
  Dynamically loads the repository url from the DATABASE_URL environment
  variable.
  """
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end
end
