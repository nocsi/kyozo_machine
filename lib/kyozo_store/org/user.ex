defmodule KyozoStore.Org.User do
  use Ecto.Schema
  @derive {Jason.Encoder, only: [:username, :avatar_url, :profile_html, :profile_markdown, :boxes]}

  @primary_key {:username, :string, []}
  @derive {Phoenix.Param, key: :username}
  schema "user" do
    field :email, :string
    field :avatar_url, :string
    field :profile_html, :string
    field :profile_markdown, :string
    timestamps()
    has_many :boxes, {"box", KyozoStore.Org.User.Box}, foreign_key: :username, on_replace: :delete
    #embeds_many :boxes, KyozoStore.Org.User.Box, on_replace: :delete
    has_one :user_auth, {"user_auth", KyozoStore.Org.UserAuth}, foreign_key: :keycloak_id, on_replace: :delete
  end
end
