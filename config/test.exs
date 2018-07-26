use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :kyozo_store, KyozoStoreWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :kyozo_store, KyozoStore.Repo,
  adapter: Ecto.Adapters.Postgres,
  hostname: System.get_env("KYOZO_DB_HOST"),
  username: System.get_env("KYOZO_DB_USER"),
  password: System.get_env("KYOZO_DB_PASS"),
  database: "kyozo_store_test",
  pool_size: Ecto.Adapters.SQL.Sandbox
