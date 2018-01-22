<% MixTemplates.ignore_file_unless(assigns[:accounts] != nil) %>
defmodule <%= @project_name_camel_case %>.AccountsFactory do
  @moduledoc """
  Provides setup functions for tests related to `<%= @project_name_camel_case %>.Accounts`. Calls the public
  interface of `<%= @project_name_camel_case %>.Accounts` to set up test data.

  In many cases, this is preferable to creating data in the database directly
  via `<%= @project_name_camel_case %>.Factory`, because it exercises the public API of `<%= @project_name_camel_case %>.Accounts`
  and reveals any usability problems it may have.

  ## Example

      import <%= @project_name_camel_case %>.AccountsFactory

      describe ".function/0" do
        setup [:create_user, :create_token]

        test "my test", %{user: user, token: token} do
          # ...
        end
      end
  """

  import ExUnit.Assertions
  import Ecto.Changeset

  alias <%= @project_name_camel_case %>.{
    Accounts,
    Accounts.User,
    Accounts.Token,
    Repo
  }

  @doc """
  Creates a user using `<%= @project_name_camel_case %>.Accounts.create_user/1`.
  """
  @spec create_user(Keyword.t) :: {:ok, [user: User.t]}
  def create_user(_) do
    {:ok, user} =
      Accounts.create_user(%{
        email: "test@example.com",
        password: "p@$$w0rd",
        password_confirmation: "p@$$w0rd"
      })

    {:ok, [user: user]}
  end

  @doc """
  Creates a login token for the `context[:user]` with `<%= @project_name_camel_case %>.Accounts.create_token/2`.

  Must be used together with `create_user/1`.
  """
  @spec create_token(Keyword.t) :: {:ok, [token: Accounts.user_token]}
  def create_token(context) do
    {:ok, token} = Accounts.tokenize({context[:user].email, "p@$$w0rd"})
    {:ok, [token: token]}
  end

  @doc """
  Creates a reset password token for the `context[:user]` with `<%= @project_name_camel_case %>.Accounts.forgot_user_password/1`.

  Must be used together with `create_user/1`.
  """
  @spec create_reset_password_token(Keyword.t) :: {:ok, [token: Accounts.user_token]}
  def create_reset_password_token(context) do
    {:ok, _} = Accounts.recover(context[:user].email)
    assert_received {:email, email}
    [[_, token]] = Regex.scan(~r/token=(.*)/, email.text_body)

    {:ok, [token: token]}
  end

  @doc """
  Causes a given token to expire.
  """
  @spec expire_token!(String.t) :: Token.t
  def expire_token!(token) do
    Token
    |> Repo.get_by(token: token)
    |> change(%{expires_at: DateTime.from_unix!(0)})
    |> Repo.update!
  end
end