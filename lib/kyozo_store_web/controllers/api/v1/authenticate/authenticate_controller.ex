defmodule KyozoStoreWeb.Api.V1.AuthenticateController do
  use KyozoStoreWeb, :controller
  alias KyozoStore.Authenticate
  alias KyozoStore.Authenticate.Auth
  alias KyozoStore.Org.User
  alias KyozoStore.Authenticate.Guardian.Plug
  import Logger
  import OAuth2

  alias OAuth2.Client
  alias OAuth2.Response

  action_fallback KyozoStoreWeb.FallbackController

  def login(conn, %{"user" => auth_params, "token" => token_desc}) do
    with {:ok, client} <- Authenticate.get_token(auth_params),
         {:ok, token} <- Authenticate.verify_token(client.token.access_token),
         {:ok, user_auth} <- Authenticate.login_with_keycloak_token(token),
         conn <- KyozoStore.Authenticate.Guardian.Plug.sign_in(conn, user_auth),
         token <- KyozoStore.Authenticate.Guardian.Plug.current_token(conn) do
         token = %{
                description: token_desc["description"],
                token: token,
                token_hash: Base.encode16(:crypto.hash(:sha256, token)),
                created_at: Timex.now()
         }
         json conn, token
    else
         {:error, %OAuth2.Response{status_code: 401, body: body}} ->
           Logger.error("Unauthorized token")
         {:error, %OAuth2.Error{reason: reason}} ->
           Logger.error("Error: #(inspect(reason)}")
         unexpected ->
           Logger.error "Got unexpected value #{inspect(unexpected)}"
    end
  end

  def validate(conn, _params) do
    case KyozoStore.Authenticate.Guardian.Plug.current_claims(conn) do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> json("Unauthorized")
      _ -> 
        conn
        |> put_status(:ok)
        |> json("OK")
    end
  end
end