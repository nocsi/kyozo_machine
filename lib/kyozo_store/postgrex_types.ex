Postgrex.Types.define(
    KyozoStore.PostgrexTypes,
    [] ++ Ecto.Adapters.Postgres.extensions(),
    json: Jason
)
