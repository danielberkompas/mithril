defmodule <%= @project_name_camel_case %>.Accounts.User do
  @moduledoc """
  Represents a user on the <%= @project_name_camel_case %> platform, for authentication purposes.

  ## Example

      %<%= @project_name_camel_case %>.Accounts.User{
        id: 123,
        email: "my@email.com",
        encrypted_password: "$2b$12$8kkvCB7/Nt8NxvsMeEthRuNetesDBqde27Nk3t6n3wQvJiXXDxDRi",
        password: nil,             # virtual
        password_confirmation: nil # virtual
        inserted_at: #{inspect(DateTime.utc_now())},
        updated_at: #{inspect(DateTime.utc_now())}
      }

  ## Usage

  You should **strongly** resist adding _any_ fields to this struct. It is not
  intended to be a global store for user state. Instead, each domain should
  manage its own user-related data, referencing only the user ID.

  Even fields like `:name` should be stored elsewhere, perhaps in a `Profile`
  domain. This schema is _only_ intended for authentication.

  Permissions associated with each user should likewise be stored in a
  `Permissions` domain, referencing the user ID.

  **Do not** create Ecto associations between this schema and schemas in other
  domains. This preserves the separation of the domains and enforces that
  all queries be made through a public domain function.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Comeonin.Bcrypt

  schema "users" do
    field :email, :string
    field :encrypted_password, :string

    # Virtual fields
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password, :password_confirmation])
    |> validate_required([:email])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/^[A-Z0-9'._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i, message: "invalid email address")
    |> validate_password()
    |> encrypt_password()
  end

  defp validate_password(%{data: %{id: id}} = changeset) when id != nil do
    changeset
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
  end

  defp validate_password(changeset) do
    changeset
    |> validate_required([:password, :password_confirmation])
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
  end

  defp encrypt_password(changeset) do
    password = get_change(changeset, :password)

    if password && !changeset.errors[:password_confirmation] do
      changeset
      |> put_change(:encrypted_password, Bcrypt.hashpwsalt(password))
      |> delete_change(:password_confirmation)
    else
      changeset
    end
  end
end