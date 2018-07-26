defmodule KyozoStore.Authenticate.Guardian do
  use Guardian, otp_app: :kyozo_store
  alias KyozoStore.Repo

  def subject_for_token(user_auth, _claims) do
    {:ok, to_string(user_auth.username)}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(claims) do
    user_auth = claims["sub"]
    |> KyozoStore.Org.get_user!
    {:ok, user_auth}
  end

  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end
end