defmodule GoogleSpreadsheet.Supervisor do
  use Supervisor

  @moduledoc """
  Supervises Google Spreadsheets. Calling `start_data_source/2` starts
  the child process and the data is immediately retrieved.
  """

  @supervisor GoogleSpreadsheet.Supervisor
  @actions %{
    request_data: DataStore.Actions.RequestGoogleSpreadsheetData
  }

  def start_link(_args),
    do: Supervisor.start_link(__MODULE__, [], name: @supervisor)

  def init(_args) do
    Supervisor.init([
      {GoogleSpreadsheet, []}
    ], strategy: :simple_one_for_one)
  end

  def start_data_source(spreadsheet_id, query_data),
    do: Supervisor.start_child(@supervisor, [spreadsheet_id, @actions, query_data])
end
