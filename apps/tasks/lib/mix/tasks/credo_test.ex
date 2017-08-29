defmodule Mix.Tasks.Credo.Test do
  use Mix.Task
  @moduledoc """
  This is a custom Mix task to run both Credo and the Tests for the umbrella applucation
  """

  @shortdoc "Runs tests and credo with one task"
  def run(_) do
    Mix.shell.cmd("MIX_ENV=test mix do test --color, credo --strict")
  end

end
