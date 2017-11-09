defmodule <%= @project_name_camel_case %>.Accounts.Token do
  @moduledoc """
  A login or reset password token which is used to identify an `Account.User`.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "user_tokens" do
    field :user_id, :integer
    field :type, :string
    field :token, :string
    field :expires_at, :utc_datetime
    field :last_used_at, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def insert_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:type, :expires_at])
    |> validate_inclusion(:type, ["login", "reset_password"])
    |> put_token()
    |> put_expires_at()
    |> put_last_used_at()
  end

  @doc false
  def update_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:expires_at, :last_used_at])
  end

  defp put_token(changeset) do
    token =
      32
      |> :crypto.strong_rand_bytes()
      |> Base.encode64()

    put_change(changeset, :token, token)
  end

  defp put_expires_at(changeset) do
    if get_change(changeset, :expires_at) do
      changeset
    else
      expires_at =
        DateTime.utc_now()
        |> DateTime.to_unix()
        |> Kernel.+(60 * 60 * 24 * 14) # Add 2 weeks
        |> DateTime.from_unix!()

      put_change(changeset, :expires_at, expires_at)
    end
  end

  defp put_last_used_at(changeset) do
    put_change(changeset, :last_used_at, DateTime.utc_now())
  end
end