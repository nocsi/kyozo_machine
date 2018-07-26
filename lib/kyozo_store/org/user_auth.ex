defmodule KyozoStore.Org.UserAuth do
  use Ecto.Schema

  @primary_key {:keycloak_id, :string, []}
  @derive {Phoenix.Param, key: :keycloak_id}
  schema "user_auth" do
    field :method, :string
    field :remote_id, :string
    belongs_to :user, KyozoStore.Org.User, [foreign_key: :username, references: :username, type: :string]
    timestamps()
  end
end