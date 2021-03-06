defmodule DataStore.Application do
  require Logger
  
  @moduledoc false

  use Application

  def start(_type, _args) do
    Logger.debug "DataStore.Application start..."
    children = [
      {GoogleSpreadsheet.Supervisor, []},
      {DataStore.DataSourceStarter, []},
      {DataStore.Receiver, []},
      {Registry, keys: :duplicate, name: DataStore.Registry}
    ]

    opts = [strategy: :one_for_one, name: DataStore.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
