defmodule DataStore.Receiver do
  use GenServer,
    start: {DataStore.Receiver, :start_link, []},
    restart: :permanent

  @name __MODULE__

  @type_data %{
    google_spreadsheet: DataStore.Action.GetGoogleSpreadsheetData
  }

  def start_link,
    do: GenServer.start_link(__MODULE__, [], name: @name)

  def handle_call({:get, id, type, query_data}, _from, state),
    do: {:reply, @type_data[type].run(id, query_data), state}
end
