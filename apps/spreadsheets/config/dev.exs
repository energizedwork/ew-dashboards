use Mix.Config

config :elixir_google_spreadsheets, :client,
  request_workers: 5,
  max_demand: 100,
  max_interval: :timer.minutes(1),
  interval: 100

config :goth, json:  {:system, "GCP_CREDENTIALS"}

config :spreadsheets,
  sheet_id: {:system, "GOOGLE_SHEET_ID"}
