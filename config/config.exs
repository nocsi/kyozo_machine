# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :kyozo_store, KyozoStore.Repo,
adapter: Ecto.Adapters.Postgres,
  database: System.get_env("KYOZO_DB_NAME"),
  hostname: System.get_env("KYOZO_DB_HOST"),
  username: System.get_env("KYOZO_DB_USER"),
  password: System.get_env("KYOZO_DB_PASS"),
  types: KyozoStore.PostgrexTypes

config :ecto, json_library: Jason
config :phoenix, :format_encoders,
  json: Jason

# General application configuration
config :kyozo_store,
  ecto_repos: [KyozoStore.Repo]

config :kyozo_store, KyozoStore.Authenticate.Client,
  realm: System.get_env("KEYCLOAK_REALM"),
  site: System.get_env("KEYCLOAK_SITE"),
  client_id: System.get_env("KEYCLOAK_CLIENT_ID"),
  client_secret: System.get_env("KEYCLOAK_CLIENT_SECRET"),
  grant_type: "password"

config :kyozo_store, KyozoStore.Authenticate,
  public_key: System.get_env("KEYCLOAK_PUBK")

# Configures the endpoint
config :kyozo_store, KyozoStoreWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: System.get_env("KYOZO_SECRET_KEY_BASE"),
  render_errors: [view: KyozoStoreWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: KyozoStore.PubSub,
  adapter: Phoenix.PubSub.PG2]

config :kyozo_store, KyozoStore.Authenticate.Guardian,
  allowed_algos: ["HS512"],
  issuer: "kyozo-store",
  ttl: { 30, :days },
  verify_module: KyozoStore.Authenticate.Guardian.JWT,
  verify_issuer: true,
  secret_key: System.get_env("KYOZO_SECRET_KEY"),
  serializer: KyozoStore.Authenticate.GuardianSerializer

config :arc,
  storage: Arc.Storage.S3,
  bucket: {:system, "MINIO_BUCKET"}

config :ex_aws,
  debug_requests: true,
  access_key_id: [{:system, "MINIO_ACCESS_KEY"}],
  secret_access_key: [{:system, "MINIO_ACCESS_SECRET"}],
  region: "local"

config :ex_aws, :s3,
  scheme: {:system, "MINIO_SCHEME"},
  region: "local",
  host: {:system, "MINIO_HOST"}

config :oauth2, debug: true

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
