defmodule KyozoStore.Repo.Migrations.CreateUserAuth do
  use Ecto.Migration

  def change do
    create table(:user_auth, primary_key: false) do
      add :keycloak_id, :string, primary_key: true
      add :method, :string
      add :remote_id, :string
      add :username, references(:user, column: :username, type: :string, on_delete: :delete_all), null: false
      timestamps()
    end
  end
end
