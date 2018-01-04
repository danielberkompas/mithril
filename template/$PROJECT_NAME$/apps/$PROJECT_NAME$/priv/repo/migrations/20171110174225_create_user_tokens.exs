<% MixTemplates.ignore_file_unless(assigns[:ecto] == "postgres" && assigns[:accounts] != nil) %>
defmodule <%= @project_name_camel_case %>.Repo.Migrations.CreateUserTokens do
  use Ecto.Migration

  def change do
    create table(:user_tokens) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :purpose, :string
      add :token, :string
      add :expires_at, :utc_datetime
      add :last_used_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create index(:user_tokens, [:user_id])
    create index(:user_tokens, [:purpose])
    create index(:user_tokens, [:token])
    create index(:user_tokens, [:expires_at])
  end
end
