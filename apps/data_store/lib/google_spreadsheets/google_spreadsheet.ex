defmodule GoogleSpreadsheet do
  require Logger

  use GenServer,
    start: {GoogleSpreadsheet, :start_link, []},
    restart: :transient

  defmodule QueryData do
    defstruct [
      sheet_name: "Sheet1",
      range: "A1:B2"]
  end

  @moduledoc """
  This is the GenServer for storing/refreshing data from google spreadsheets. When started it represents a
  single spreadsheet and refreshes the data on the `@update_interval`. The data is populated from the init
  function but it does not block the startup of the process. Once the data is refreshed calling `data/1`
  returns the data for the given spredsheet.

  Example:

  iex> GoogleSpreadsheet.data("1goNDckM11s023VmhhsuV2Ll3D-f61J2Vv2RLWwcy8q4")
  %{"majorDimension" => "ROWS", "range" => "Sheet1!A1:B2",
  "values" => [["Column A", "Column B"],
  ["Value A1", "Value B1"],
  ["Value A2", "Value B2"]}

  """
  @update_interval 10_000

  def start_link(spreadsheet_id, actions, query_data) do
    Logger.debug "GoogleSpreadsheet [#{spreadsheet_id}] start_link..."
    GenServer.start_link(__MODULE__, [spreadsheet_id, actions, query_data])
  end

  def data(spreadsheet_id) do
    spreadsheet_id
    |> String.to_existing_atom()
    |> GenServer.call(:data)
  end

  def init([spreadsheet_id, actions, query_data]) do
    Logger.debug "GoogleSpreadsheet [#{spreadsheet_id}] init..."
    Registry.register(DataStore.Registry, :google_spreadsheet, {spreadsheet_id, query_data.sheet_name, query_data.range})
    send(self(), :refresh_data)
    {:ok, %{spreadsheet_id: spreadsheet_id, actions: actions, query_data: query_data}}
  end

  # internal call
  def handle_info(:refresh_data, %{spreadsheet_id: spreadsheet_id, actions: actions, query_data: query_data} = state) do
    Logger.debug "GoogleSpreadsheet [#{spreadsheet_id}] refreshing..."
    Process.send_after(self(), :refresh_data, @update_interval)

    updated_data =
      case actions[:request_data].run(spreadsheet_id, query_data) do
        {:ok, body} ->
          body
        {:error, _} ->
          Logger.warn "GoogleSpreadsheet [#{spreadsheet_id}] :error, will leave local data as is.."
          state[:data]
      end

    {:noreply, Map.put(state, :data, updated_data)}
  end

  # synchronous
  def handle_call(:data, _from, %{data: data} = state),
    do: {:reply, data, state}
end
