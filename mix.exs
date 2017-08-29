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
      {:excoveralls, "~> 0.7", only: :test}
    ]
  end

  defp aliases do
    ["coveralls": ["coveralls.detail -u"]]
  end
end
