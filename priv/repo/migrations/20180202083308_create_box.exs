defmodule KyozoStore.Repo.Migrations.CreateBox do
  use Ecto.Migration

  def change do
    create table(:box, primary_key: false) do
      add :name, :string, primary_key: true
      add :short_description, :string
      add :description_html, :string
      add :description_markdown, :string
      add :private, :boolean, default: true , null: false
      add :versions, :jsonb, default: "[]"
      add :current_version, :json
      add :username, references(:user, column: :username, type: :string, on_delete: :delete_all), null: false
      timestamps()
    end
    execute("CREATE INDEX versions_search_index ON box USING gin(to_tsvector('english', versions))")
    execute("CREATE INDEX box_versions_index_version ON box USING gin((versions->'version'))")
    execute("CREATE INDEX box_versions_index_providers ON box USING gin((versions->'providers'))")
  end
end
