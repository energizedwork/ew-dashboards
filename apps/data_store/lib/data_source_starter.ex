defmodule DataStore.DataSourceStarter do
  use GenServer,
    start: {DataStore.DataSourceStarter, :start_link, []},
    restart: :permanent,
    type: :worker

  @moduledoc """
  Starts data sources based on the data source type.
  """

  @name __MODULE__
  @data_source_supervisors %{
    google_spreadsheet: GoogleSpreadsheet.Supervisor
  }

  def start_link,
    do: GenServer.start_link(__MODULE__, [], name: @name)

  @doc """
  Starts the new data source if it isn't started.
  """
  def handle_cast({:start_data_source, %{type: type, name: name, query_data: query_data}}, state) do
    with [] <- Registry.match(DataStore.Registry, type, name) do
      @data_source_supervisors[type].start_data_source(name, query_data)
    end
    {:noreply, state}
  end
end
