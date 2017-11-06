defmodule GoogleSpreadsheet.Supervisor do
  require Logger

  use Supervisor

  @moduledoc """
  Supervises Google Spreadsheets. Calling `start_data_source/2` starts
  the child process and the data is immediately retrieved.
  """

  @supervisor GoogleSpreadsheet.Supervisor
  @actions %{
    request_data: DataStore.Action.RequestGoogleSpreadsheetData
  }

  def start_link(_args) do
    Logger.debug "GoogleSpreadsheet.Supervisor start_link..."
    Supervisor.start_link(__MODULE__, [], name: @supervisor)
  end

  def init(_args) do
    Logger.debug "GoogleSpreadsheet.Supervisor init..."
    Supervisor.init([
      {GoogleSpreadsheet, []}
    ], strategy: :simple_one_for_one)
  end

  def start_data_source(spreadsheet_id, query_data) do
    Logger.debug "GoogleSpreadsheet.Supervisor start_data_source..."
    Supervisor.start_child(@supervisor, [spreadsheet_id, @actions, query_data])
  end
end
