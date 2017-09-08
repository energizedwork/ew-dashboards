defmodule Spreadsheets.Client.Google do
  @behaviour Spreadsheets.Client

  @moduledoc """

  Client implementation for the Google spreadsheets library. Depends on the client behaviour

  """

  @spreadsheet GSS.Spreadsheet
  @supervisor GSS.Spreadsheet.Supervisor

  @spec get_spreadsheet(spreadsheet :: %{required(:name) => String.t}) :: {:ok, pid :: Pid}
  def get_spreadsheet(%{name: name}) do
    spreadsheet_supervisor().spreadsheet(name)
  end

  @spec fetch_data(spreadsheet :: %{required(:pid) => Pid.t, required(:rows) => Integer.t, required(:cols) => Integer.t}) :: {:ok, spreadsheet :: List}
  def fetch_data(%{pid: pid, rows: rows, cols: cols}) do
    1..rows
    |> Enum.map(&(&1))
    |> read_rows(cols, pid)
  end

  defp read_rows(rows, cols, pid) do
    spreadsheet().read_rows(pid, rows, column_to: cols, pad_empty: true)
  end

  defp spreadsheet do
    Application.get_env(:spreadsheets, :google_client, @spreadsheet)
  end

  defp spreadsheet_supervisor do
    Application.get_env(:spreadsheets, :google_client_supervisor, @supervisor)
  end

end
