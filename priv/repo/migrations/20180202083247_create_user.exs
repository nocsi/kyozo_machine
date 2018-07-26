defmodule KyozoStore.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:user, primary_key: false) do
      add :username, :string, primary_key: true
      add :email, :string
      add :avatar_url, :string
      add :profile_html, :string
      add :profile_markdown, :string
      #add :boxes, {:array, :map}, default: []
      timestamps()
    end
  end
end
