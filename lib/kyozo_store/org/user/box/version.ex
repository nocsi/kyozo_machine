defmodule KyozoStore.Org.User.Box.Version do
  use Ecto.Schema
  import Ecto.Changeset
  @derive {Jason.Encoder, only: [
    :version, 
    :status,
    :description_html, 
    :description_markdown, 
    :inserted_at, 
    :updated_at, 
    :number, 
    :release_url,
    :revoke_url,
    :providers
  ]}

  #@primary_key false
  @derive {Phoenix.Param, key: :version}
  @primary_key {:version, :string, autogenerate: false}
  embedded_schema  do
    field :description, :string, virtual: true
    field :description_html, :string
    field :description_markdown, :string
    field :number, :string
    field :release_url, :string
    field :revoke_url, :string
    field :status, :string, default: "unreleased"
    timestamps()
    embeds_many :providers, KyozoStore.Org.User.Box.Version.Provider, on_replace: :delete
  end

  @doc false
  #def changeset(%Version{} = version, attrs \\ %{}) do
  def changeset(struct, params) do
    struct
    |> cast(params, [:version, :status, :description, :number, :release_url, :revoke_url])
    |> validate_required([:version])
    |> description_markup
    |> cast_embed(:providers, with: &KyozoStore.Org.User.Box.Version.Provider.changeset/2)
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
