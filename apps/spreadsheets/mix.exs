defmodule Spreadsheets.Mixfile do
  use Mix.Project

  def project do
    [
      app: :spreadsheets,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Spreadsheets.Application, []}
    ]
  end

  defp deps do
    [
      {:elixir_google_spreadsheets, "~> 0.1.7"},
      {:tasks, in_umbrella: true, only: [:dev, :test]}
    ]
  end
end
