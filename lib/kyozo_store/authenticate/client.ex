defmodule KyozoStore.Authenticate.Client do
  alias OAuth2.Client

  defp config() do
    config = Application.get_env(:kyozo_store, __MODULE__, [])
    {realm, config} = Keyword.pop(config, :realm)
    {site, config} = Keyword.pop(config, :site)
    {client_id, config} = Keyword.pop(config, :client_id)
    {client_secret, config} = Keyword.pop(config, :client_secret)
    {grant_type, config} = Keyword.pop(config, :grant_type)

    [strategy: OAuth2.Strategy.Password,
      site: "#{site}/auth",
      authorize_url: "/realms/#{realm}/protocol/openid-connect/auth",
      token_url: "/realms/#{realm}/protocol/openid-connect/token",
      client_id: client_id,
      client_secret: client_secret,
      grant_type: grant_type]
    |> Keyword.merge(config)
  end

  def new(opts \\ []) do
    config()
    |> Keyword.merge(opts)
    |> IO.inspect
    |> Client.new
  end

  def me(%Client{} = client) do
    realm = 
      config()
      |> Keyword.get(:realm)
    client
    |> Client.put_header("accept", "application/json")
    |> Client.get("/realms/#{realm}/protocol/openid-connect/userinfo")
  end
end