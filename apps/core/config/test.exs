use Mix.Config

config :core, Core.Repo,
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox,
  database: "ew_dashboard_test"

config :logger, :console,
  level: :error
