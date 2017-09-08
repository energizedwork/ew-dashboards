use Mix.Config

# Configure your database
if System.get_env("DATABASE_URL") do
  config :core, Core.Repo,
    adapter: Ecto.Adapters.Postgres,
    url: System.get_env("DATABASE_URL"),
    pool: Ecto.Adapters.SQL.Sandbox
else
  config :core, Core.Repo,
    adapter: Ecto.Adapters.Postgres,
    pool: Ecto.Adapters.SQL.Sandbox,
    database: "ew_dashboard_test"
end

config :logger, :console,
  level: :error
