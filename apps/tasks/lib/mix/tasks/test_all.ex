defmodule Mix.Tasks.Test.All do
  use Mix.Task
  @moduledoc """
  This is a custom Mix task to run both Credo and the Tests for the umbrella applucation
  """

  @shortdoc "Run tests, credo, and dialyzer with one task"
  def run(_) do
    Mix.shell.cmd("MIX_ENV=test mix do dialyzer, test --color, credo --strict")
    Mix.shell.cmd("MIX_ENV=test mix coveralls -u")
  end

end
