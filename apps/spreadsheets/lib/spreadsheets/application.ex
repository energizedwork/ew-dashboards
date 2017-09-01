defmodule Spreadsheets.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Spreadsheets.Data.Supervisor, name: Spreadsheets.Data.Supervisor}
    ]

    opts = [strategy: :one_for_one, name: Spreadsheets.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
