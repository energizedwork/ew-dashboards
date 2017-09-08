defmodule Core do
  use Application

  @moduledoc """

  The Core application module for supervising processes in Core. When adding this application
  to another projects dependencies remember to add it to the list of applications in the mix
  file.

  """

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(Core.Repo, [])
    ]

    opts = [strategy: :one_for_one, name: Core.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
