defmodule KyozoStore.Org.User.Box do
  use Ecto.Schema
  import Ecto.Changeset
  alias KyozoStore.Org.User.Box
  @derive {Jason.Encoder, only: [
    :inserted_at, 
    :updated_at, 
    :name, 
    :username, 
    :short_description, 
    :description_html,
    :description_markdown,
    :private,
    :current_version,
    :versions
  ]}

  @derive {Phoenix.Param, key: :name}
  @primary_key {:name, :string, []}
  schema "box" do
    field :private, :boolean, default: true
    field :description, :string, virtual: true
    field :short_description, :string
    field :description_html, :string
    field :description_markdown, :string
    timestamps()
    embeds_many :versions, KyozoStore.Org.User.Box.Version, on_replace: :delete
    embeds_one :current_version, KyozoStore.Org.User.Box.Version, on_replace: :delete
    belongs_to :user, KyozoStore.Org.User, [foreign_key: :username, references: :username, type: :string]
  end

  @doc false
  def changeset(%Box{} = box, attrs) do
    box
    |> cast(attrs, [:username, :name, :short_description, :description, :private])
    |> cast_embed(:versions)
    |> validate_required([:username, :name, :short_description, :private])
    |> description_markup
    |> assoc_constraint(:user)
    |> unique_constraint(:name)
  end

  defp description_markup(changeset) do
    case get_change(changeset, :description) do
      nil ->
        changeset
      description ->
        changeset 
          |> put_change(:description_markdown, description)
          |> put_change(:description_html, "<p>" <> description <> "</p>\n")
    end
  end
end
