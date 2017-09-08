defmodule EwDashboards.Mixfile do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        "coveralls": :test,
        "coveralls.detail": :test,
        "coveralls.html": :test
      ],
      aliases: aliases()
    ]
  end

  defp deps do
    [
      {:excoveralls, "~> 0.7", only: [:dev, :test]}
    ]
  end

  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.migrate", "test"]]
  end
end
