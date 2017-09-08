defmodule Core.Mixfile do
  use Mix.Project

  def project do
    [
      app: :core,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env),
      start_permanent: Mix.env == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls]
    ]
  end

  def application do
    [
      mod: {Core, []},
      extra_applications: [:logger, :ecto, :postgrex]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  defp deps do
    [
      {:postgrex, ">= 0.0.0"},
      {:ecto, "~> 2.2"},
      {:tasks, in_umbrella: true, only: [:dev, :test]}
    ]
  end
end
