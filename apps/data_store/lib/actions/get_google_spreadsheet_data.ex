defmodule DataStore.Action.GetGoogleSpreadsheetData do

  @moduledoc """
  Gets the data from a spreadsheet.
  """

  def run(spreadsheet_id, %{sheet_name: sheet_name, range: range} = query_data) do
    {spreadsheet_id, sheet_name, range}
    |> query_registry()
    |> extract_or_create_pid(spreadsheet_id, query_data)
    |> call()
  end

  defp extract_or_create_pid([{pid, _}], _spreadsheet_id, _query_data), do: pid
  defp extract_or_create_pid([], spreadsheet_id, query_data) do
    {:ok, pid} = GoogleSpreadsheet.Supervisor.start_data_source(spreadsheet_id, query_data)
    pid
  end

  defp query_registry({spreadsheet_id, sheet_name, range}) do
    DataStore.Registry
    |> Registry.match(:google_spreadsheet,
    {:"$1", :"$2", :"$3"},
    [
      {:==, :"$1", spreadsheet_id},
      {:==, :"$2", sheet_name},
      {:==, :"$3", range}
    ])
  end

  defp call(pid), do: GenServer.call(pid, :data)

end
