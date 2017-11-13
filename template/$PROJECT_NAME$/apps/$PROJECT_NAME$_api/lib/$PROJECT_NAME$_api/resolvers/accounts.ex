<% MixTemplates.ignore_file_unless(assigns[:accounts] != nil) %>
defmodule <%= @project_name_camel_case %>API.Resolvers.Accounts do
  @moduledoc """
  A resolver for `<%= @project_name_camel_case %>.Account`. Relies on `<%= @project_name_camel_case %>API.Middleware.HandleErrors`
  to handle errors from the resolver functions.
  """

  alias <%= @project_name_camel_case %>.Accounts

  @doc """
  Resolver function for creating users. Calls `<%= @project_name_camel_case %>.Accounts.create_user/1`
  """
  def create_user(%{input: params}, _context) do
    with {:ok, user} <- Accounts.create_user(params) do
      {:ok, %{user: user}}
    end
  end

  @doc """
  Resolver function returning the current user. Calls `<%= @project_name_camel_case %>.Accounts.get_user_by_token/1`
  to identify the user.
  """
  def current_user(_args, %{context: context}) do
    Accounts.get_user_by_token(context[:token])
  end

  @doc """
  Resolver function to update the current user. Calls `<%= @project_name_camel_case %>.Accounts.update_user/2`
  to perform the update.
  """
  def update_current_user(%{input: params}, %{context: context}) do
    with {:ok, %{user: user}} <- Accounts.update_user(context[:token], params) do
      {:ok, %{user: user}}
    else
      {:error, :user, changeset, _changes} ->
        {:error, changeset}

      error ->
        error
    end  
  end

  @doc """
  Resolver function to create a login token for a given set of user credentials.
  Calls `<%= @project_name_camel_case %>.Accounts.create_login_token/2`.
  """
  def login_user(%{input: params}, _context) do
    with {:ok, token, user} <- Accounts.create_login_token(params[:email], params[:password]) do
      {:ok, %{token: token, user: user}}
    end
  end
end