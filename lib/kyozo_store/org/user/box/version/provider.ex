defmodule KyozoStore.Org.User.Box.Version.Provider do
  use Ecto.Schema
  import Ecto.Changeset
  @derive {Jason.Encoder, only: [
    :name, 
    :inserted_at, 
    :updated_at, 
    :hosted,
    :hosted_token, 
    :original_url, 
    :download_url
  ]}

  @derive {Phoenix.Param, key: :name}
  @primary_key {:name, :string, autogenerate: false}
  embedded_schema do
    field :hosted, :boolean, default: true
    field :hosted_token, :string
    field :url, :string, virtual: true
    field :original_url, :string
    field :download_url, :string
    timestamps()
  end

  @doc false
  #def changeset(struct, params \\ %{}) do
  def changeset(struct, params) do
    struct
    |> cast(params, [:name, :hosted, :hosted_token, :url, :original_url, :download_url])
    |> validate_required([:name])
    |> url_markup
  end

  defp url_markup(changeset) do
    case get_change(changeset, :url) do
      nil ->
        changeset
      url ->
        changeset
        |> put_change(:original_url, url)
        |> put_change(:download_url, url)
    end
  end

end
