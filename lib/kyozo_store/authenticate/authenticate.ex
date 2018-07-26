defmodule KyozoStore.Authenticate do
  use Timex
  require Logger
  require OAuth2.Client
  require IEx
  @moduledoc """
  The Authenticate context.
  """
  
  alias KyozoStore.Authenticate.Auth
  alias KyozoStore.Repo
  alias JOSE.JWK
  defmodule Auth do
    defstruct description: "",
      token: "",
      token_hash: "",
      created_at: ""
  end

  @type user          :: binary
  @type access_token  :: binary
  @type refresh_token :: binary | nil
  @type expires_at    :: integer
  @type token_type    :: binary
  use OAuth2.Strategy

  @doc """
  Creates a auth.

  ## Examples

      iex> create_auth(%{field: value})
      {:ok, %Auth{}}

      iex> create_auth(%{field: bad_value})
      {:error, ...}

  """
  def get_token(%{"login" => username, "password" => password}) do
    KyozoStore.Authenticate.Client.new()
    |> OAuth2.Client.get_token([username: username, password: password])
  end

  @doc """
  Attemps to verify that the passed `token` can be trusted.
  ## Example
      iex> verify_token(nil)
      {:error, :not_authenticated}
      iex> verify_token("abc123")
      {:error, "Invalid signature"}
  """
  @spec verify_token(String.t | nil) :: {atom(), Joken.Token.t | atom()}
  def verify_token(nil), do: {:error, :not_authenticated}
  def verify_token(token) do
    joken =
      token
      |> Joken.token()
      |> Joken.with_validation("exp", fn(exp) ->
        case DateTime.from_unix(exp) do
          {:ok, dt} -> DateTime.compare(dt, DateTime.utc_now()) == :gt
          {:error, _} -> false
        end
      end, "Invalid exp")
      |> Joken.with_signer(signer_key())
      |> Joken.verify()
    
    case joken do
      %{error: nil} -> {:ok, joken}
      %{error: message} -> {:error, message}
    end
  end

  @doc """
  Returns the configured `public_key` or `hmac` key used to sign the token.
  ### Example
      iex> %Joken.Signer{} = signer_key()
      %Joken.Signer{jwk: %{"k" => "YWtiYXI", "kty" => "oct"}, jws: %{"alg" => "HS512"}}
  """
  @spec signer_key() :: Joken.Signer.t
  def signer_key() do
    {config, _} =
      Application.get_env(:kyozo_store, __MODULE__, [])
      |> Keyword.split([:hmac, :public_key])
    
    case config do
      [hmac: hmac] ->
        hmac
        |> Joken.hs256()
      [public_key: public_key] ->
        public_key
        |> JWK.from_pem()
        |> Joken.rs256()
      _ ->
        raise "No signer configuration present for #{__MODULE__}"
    end
  end

  def login_with_keycloak_token(decoded_jwt) do
    with {:ok, user} <- get_user(decoded_jwt),
         user_auth <- get_user_auth(decoded_jwt, user) do
         {:ok, user_auth}
    else
         unexpected ->
           Logger.error "Got unexpected value #{inspect(unexpected)}"
    end
  end

  defp get_user(decoded_jwt) do
    username = decoded_jwt.claims["username"]
    email = decoded_jwt.claims["email"]
    case KyozoStore.Org.get_user!(username) do
      nil ->
        {:ok, user} = KyozoStore.Org.create_user(%{username: username, email: email})
        {:ok, user}
      user -> 
        user
        |> Repo.preload(:user_auth)
        {:ok, user}
    end
  end

  defp get_user_auth(decoded_jwt, user) do
    username = decoded_jwt.claims["username"]
    keycloak_id = decoded_jwt.claims["sub"]
    case KyozoStore.Org.get_userauth!(keycloak_id) do
      nil ->
        {:ok, user_auth} = KyozoStore.Org.create_userauth(%{method: "username", remote_id: username, keycloak_id: keycloak_id, username: user.username})
        user_auth
        |> Repo.preload(:user)
      user_auth ->
        user_auth
        |> Repo.preload(:user)
    end
  end
end  