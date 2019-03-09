defmodule <%= @project_name_camel_case %>.Accounts.Token do
  @moduledoc """
  A login or recovery token which is used to identify an `Lab.Accounts.User`.

  ## Example

      %Lab.Accounts.Token{
        id: 123,
        purpose: :any,
        token: "ZKtJtotypydGVqGPaU/yfXrw5eNSkdvEmpueODc/UwI=",
        expires_at: #{inspect(DateTime.utc_now())},
        last_used_at: #{inspect(DateTime.utc_now())}
      }
  """

  use <%= @project_name_camel_case %>.Schema

  defmodule Purpose do
    use Exnumerator, values: [:any, :recovery]
  end

  defmodule HMAC do
    use Authority.Ecto.HMAC, secret: {:app_env, :<%= @project_name %>, :token_secret}
  end

  schema "user_tokens" do
    belongs_to :user, <%= @project_name_camel_case %>.Accounts.User

    field :purpose, Purpose
    field :token, HMAC
    field :expires_at, :utc_datetime
    field :last_used_at, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:purpose, :expires_at, :last_used_at])
    |> put_token(:token)
    |> put_token_expiration(:expires_at, :purpose, recovery: {24, :hours}, any: {14, :days})
    |> put_last_used_at()
  end

  defp put_last_used_at(changeset) do
    put_change(changeset, :last_used_at, DateTime.truncate(DateTime.utc_now(), :second))
  end
end
