<% MixTemplates.ignore_file_unless(assigns[:accounts] != nil) %>
defmodule <%= @project_name_camel_case %>API.Resolvers.Accounts do
  @moduledoc """
  A resolver for <%= @project_name_camel_case %>.Users.
  """

  alias <%= @project_name_camel_case %>.Accounts

  def create_user(%{input: params}, _context) do
    with {:ok, user} <- Accounts.create_user(params) do
      {:ok, %{user: user}}
    end
  end

  def current_user(_args, %{context: context}) do
    Accounts.get_user_by_token(context[:token])
  end

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

  def login_user(%{input: params}, _context) do
    with {:ok, token, user} <- Accounts.create_login_token(params[:email], params[:password]) do
      {:ok, %{token: token, user: user}}
    end
  end
end