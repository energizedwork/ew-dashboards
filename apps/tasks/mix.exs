defmodule Tasks.Mixfile do
  use Mix.Project

  def project do
    [
      app: :tasks,
      version: "0.1.0",
      build_path: "../../_build",
      elixir: "~> 1.5",
      deps: deps(),
      dialyzer: [
        plt_add_deps: :apps_direct,
        plt_apps: [:dialyzer, :elixir, :kernel, :mix, :stdlib],
        plt_add_apps: [:elixir],
        paths: [
          "../../_build/test/lib/tasks/ebin",
          "../../_build/test/lib/schemas/ebin"
        ],
        flags: [
          "-Wunmatched_returns",
          :error_handling,
          :race_conditions,
          :underspecs
        ]
      ],
    ]
  end

  defp deps do
    [
      {:credo, "~> 0.8.6", only: :test},
      {:dialyxir, "~> 0.5", only: :test, runtime: false}
    ]
  end

end
