defmodule Tasks.Mixfile do
  use Mix.Project

  def project do
    [
      app: :tasks,
      version: "0.1.0",
      build_path: "../../_build",
      elixir: "~> 1.5",
    ]
  end

end
