defmodule KyozoStore.Authenticate.GuardianSerializer do
  @behaviour Guardian.Serializer

  alias KyozoStore.Repo
  alias KyozoStore.Org.UserAuth

  def for_token(user_auth = %UserAuth{}), do: { :ok, "UserAuth:#{user_auth.id}" }
  def for_token(_), do: { :error, "Unknown resource type" }

  def from_token("UserAuth:" <> id), do: { :ok, Repo.get(UserAuth, id) }
  def from_token(_), do: { :error, "Unknown resource type" }
end