defmodule <%= @project_name_camel_case %>.Accounts do
  @moduledoc """
  Provides account registration, login tokens, and forgot password functionality.

  ## Usage

  Many <%= @project_name_camel_case %> functions require authentication. This module helps you generate
  the needed tokens to authenticate against those function calls.

  1. **Create a user.** Obviously, you'll need a user to be able to authenticate.
     
     ```elixir
     {:ok, user} = 
       Accounts.create_user(%{
         email: "your@email.com",
         password: "password",
         password_confirmation: "password"
       })
     ```

  2. **Create a login token.** You can exchange your email and password for a login
     token, which you can then use to authenticate against other <%= @project_name_camel_case %> public API
     functions.

     ```elixir
     {:ok, token, _user} = Accounts.create_login_token("your@email.com", "password")
     ```

     You should store this token, so that the user doesn't have to submit their
     credentials again and again. In Phoenix, you can store it in the session.
     For a mobile API, you can return it to the mobile app and let the mobile app
     store it locally.

  3. **Pass the login token to other domain functions.** If a <%= @project_name_camel_case %> function requires
     authentication, you will pass your login token as the final argument to it.

     ```elixir
     <%= @project_name_camel_case %>.Secret.super_secret_function(...args, token)
     ```
  """

  @type user_token :: String.t
  @type user_token_type :: :login | :reset_password
  @type reset_token :: String.t

  import Ecto.Query

  alias Ecto.Multi
  alias Comeonin.Bcrypt
  alias <%= @project_name_camel_case %>.{
    Accounts.User,
    Accounts.Token,
    Notifications,
    Repo
  }

  @doc """
  Convenience function to make it easier to build HTML forms for user
  registration and reset password.

  ## Examples

      # New action
      {:ok, changeset} = Accounts.change_user()
      render conn, "new.html", changeset: changeset

      # Edit action
      {:ok, changeset} = Accounts.change_user(token)
      render conn, "edit.html", changeset: changeset
  """
  @spec change_user(user_token | User.t) :: 
    {:ok, Ecto.Changeset.t} |
    {:error, :invalid_token}
  def change_user(token_or_user \\ nil)
  def change_user(nil) do
    {:ok, User.insert_changeset(%User{})}
  end
  def change_user(%User{} = user) do
    {:ok, User.update_changeset(user)}
  end
  def change_user(token) when is_binary(token) do
    with {:ok, type} <- get_token_type(token),
         {:ok, user} <- get_user_by_token(token, type)
    do
      change_user(user)
    end
  end

  @doc """
  Registers a new user on the platform.

  ## Example

      iex> Accounts.create_user(%{
      ...>   "email" => "test@example.com", 
      ...>   "password" => "password",
      ...>   "password_confirmation" => "password"
      ...> })
      {:ok, %Accounts.User{...}}
  """
  @spec create_user(map) ::
    {:ok, User.t} |
    {:error, Ecto.Changeset.t}
  def create_user(params) do
    %User{}
    |> User.insert_changeset(params)
    |> Repo.insert
  end

  @doc """
  Creates a user login token with the given credentials.

  You can then store this token in your session (Phoenix) or pass it to
  your API client to store.

  ## Example

      iex> Accounts.create_login_token("test@email.com", "password")
      {:ok, "...", %Accounts.User{}}
  """
  @spec create_login_token(String.t, String.t) ::
    {:ok, user_token, User.t} |
    {:error, :invalid_credentials}
  def create_login_token(email, password) when is_nil(email) or is_nil(password) do
    {:error, :invalid_credentials}
  end
  def create_login_token(email, password) do
    with %User{} = user <- Repo.get_by(User, email: email),
         true <- Bcrypt.checkpw(password, user.encrypted_password),
         {:ok, token} <- create_user_token(user, :login)
    do
      {:ok, token.token, user}
    else
      _ ->
        {:error, :invalid_credentials}
    end
  end

  @doc """
  Finds a user based on the given token. See `create_login_token/2`
  for more details on how to create tokens.

  IMPORTANT: Do not use this function to fetch and pass users to
  other domains' functions. Instead, pass user tokens to those
  functions and let them internally identify the user.

  ## Example

      iex> Accounts.get_user_by_token("...")
      {:ok, %Accounts.User{}}
  """
  @spec get_user_by_token(user_token, user_token_type) ::
    {:ok, User.t} |
    {:error, :invalid_token}
  def get_user_by_token(token, type \\ :login)
  def get_user_by_token(nil, _type), do: {:error, :invalid_token}
  def get_user_by_token(token, type) do
    query =
      User
      |> join(:left, [u], t in Token, t.user_id == u.id)
      |> where([u, t], t.type == ^to_string(type))
      |> where([u, t], t.token == ^token)
      |> where([u, t], t.expires_at > ^DateTime.utc_now())

    with %User{} = user <- Repo.one(query) do
      token_used(token)
      {:ok, user}
    else
      _ ->
        {:error, :invalid_token}
    end
  end

  @doc """
  Sends a reset password token to the user with the given email address, if
  they exist.

  ## Configuration

  See `<%= @project_name_camel_case %>.Notifications.forgot_password/2` for details on how to configure
  the URL the "reset password" email will link to.

  ## Examples

      iex> Accounts.forgot_user_password("existing@email.com")
      :ok

      iex> Accounts.forgot_user_password("nonexistent@email.com")
      {:error, :invalid_email}
  """
  @spec forgot_user_password(String.t) ::
    {:ok, %{}} |
    {:error, :invalid_email}
  def forgot_user_password(email) do
    with %User{} = user <- Repo.get_by(User, email: email),
         {:ok, token} <- create_user_token(user, :reset_password)
    do
      Notifications.forgot_password(email, token.token)
    else
      nil ->
        {:error, :invalid_email}
    end
  end

  @doc """
  Updates an `Account.User`'s attributes, including password.

  ## Example

      iex> Account.update_user(token, %{
        "password" => "new_password",
        "password_confirmation" => "new_password"
      })
  """
  @spec update_user(user_token, map) ::
    {:ok, %{user: User.t}} |
    {:error, :user, Ecto.Changeset.t, map} |
    {:error, :invalid_token}
  def update_user(token, params \\ %{}) do
    with {:ok, type} <- get_token_type(token),
         {:ok, user} <- get_user_by_token(token, type)
    do
      changeset = User.update_changeset(user, params)

      Multi.new
      |> Multi.update(:user, changeset)
      |> revoke_tokens(type, token, changeset)
      |> Repo.transaction
    end
  end

  # If the user's password was changed, and the user is currently logged in,
  # revoke all other tokens for this user, keeping the current token active.
  defp revoke_tokens(multi, :login, token, %{changes: %{password: _}} = changeset) do
    query = 
      Token
      |> where(user_id: ^changeset.data.id)
      |> where([t], t.token != ^token)

    Multi.delete_all(multi, :tokens, query)
  end

  # If the user's password was changed, and the user is resetting their password
  # (not logged in), then revoke all tokens.
  defp revoke_tokens(multi, :reset_password, _token, %{changes: %{password: _}} = changeset) do
    Multi.delete_all(multi, :tokens, where(Token, user_id: ^changeset.data.id))
  end

  # In all other cases, don't revoke any tokens.
  defp revoke_tokens(multi, _token_type, _token, _changeset) do
    multi
  end

  @doc """
  Preemptively validates whether a token has expired or not. Use this to 
  warn a user that they need to re-authenticate before allowing them to
  attempt an action.

  ## Examples

      iex> Accounts.validate_token("valid")
      :ok

      iex> Accounts.validate_token("nonexistent")
      {:error, :not_found}

      iex> Accounts.validate_token("expired")
      {:error, :expired}
  """
  @spec validate_token(user_token) ::
    :ok |
    {:error, :not_found} |
    {:error, :expired}
  def validate_token(nil), do: {:error, :not_found}
  def validate_token(token) do
    with %Token{} = token <- Repo.get_by(Token, token: token),
         :gt <- DateTime.compare(token.expires_at, DateTime.utc_now())
    do
      :ok
    else
      nil ->
        {:error, :not_found}
      op when op in [:eq, :lt] ->
        {:error, :expired}
    end
  end

  defp get_token_type(nil), do: {:error, :invalid_token}
  defp get_token_type(token) do
    token = Repo.get_by(Token, token: token)

    if token do
      {:ok, String.to_existing_atom(token.type)}
    else
      {:error, :invalid_token}
    end
  end

  defp token_used(token) do
    Token
    |> where(token: ^token)
    |> Repo.update_all(set: [last_used_at: DateTime.utc_now()])
  end

  defp create_user_token(user, type) do
    %Token{user_id: user.id}
    |> Token.insert_changeset(%{type: Atom.to_string(type)})
    |> Repo.insert()
  end
end