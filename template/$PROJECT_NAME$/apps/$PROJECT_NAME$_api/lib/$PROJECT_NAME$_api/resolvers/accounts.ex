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
  Resolver function returning the current user. Calls `<%= @project_name_camel_case %>.Accounts.authenticate/1`
  to identify the user.
  """
  def current_user(_args, %{context: %{current_user: user}}) do
    {:ok, user}
  end

  def current_user(_args, _context) do
    {:error, :invalid_token}
  end

  @doc """
  Resolver function to update the current user. Calls `<%= @project_name_camel_case %>.Accounts.update_user/2`
  to perform the update.
  """
  def update_current_user(%{input: params}, %{context: %{token: token}}) do
    with {:ok, user} <- Accounts.update_user(token, params) do
      {:ok, %{user: user}}
    end  
  end

  def update_current_user(_args, _context) do
    {:error, :invalid_token}
  end

  @doc """
  Resolver function to create a login token for a given set of user credentials.
  Calls `<%= @project_name_camel_case %>.Accounts.tokenize/1`.
  """
  def login_user(%{input: params}, _context) do
    with {:ok, token} <- Accounts.tokenize({params[:email], params[:password]}),
         {:ok, user} <- Accounts.authenticate(token) do
      {:ok, %{token: token.token, user: user}}
    end
  end
end