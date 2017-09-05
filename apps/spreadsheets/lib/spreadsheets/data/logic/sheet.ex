defmodule Spreadsheets.Data.Logic.Sheet do

  @moduledoc """

  This module serves as the logic handler for the Sheets GenServer.

  """

  alias Spreadsheets.{
    Client.Google,
    Data.Sheet,
    Data.Converter
  }

  @callback retrieve_data(sheet :: %Sheet{}) :: {:ok, sheet :: %Sheet{}} :: {:error, reason :: Binary}
  @callback cell(sheet :: %Sheet{}, row :: Integer, col :: Integer) :: cell :: Binary
  @callback all(sheet :: %Sheet{}) :: all :: Map

  @default_refresh_rate 30_000

  @spec retrieve_data(sheet :: %Sheet{}) :: {:ok, sheet :: %Sheet{}} :: {:error, reason :: Binary}
  def retrieve_data(%Sheet{} = sheet) do
    with {:ok, pid} <- client().get_spreadsheet(sheet),
         {:ok, sheet} <- merge_pid(sheet, pid),
         {:ok, sheet} <- update_refresh_rate(sheet),
         {:ok, data} <- client().fetch_data(sheet),
         {:ok, data} <- convert_to_map(data),
         {:ok, _sheet} = result <- merge_data(sheet, data) do
      result
    else
      error ->
        {:error, error}
    end
  end

  @spec cell(sheet :: %Sheet{}, row :: Integer, col :: Integer) :: cell :: Binary
  def cell(%Sheet{} = sheet, row, col),
    do: sheet.sheet[row][col]

  @spec all(sheet :: %Sheet{}) :: all :: Map
  def all(%Sheet{} = sheet),
    do: sheet.sheet

  defp convert_to_map(sheet),
    do: Converter.from_list(sheet)

  defp merge_data(%Sheet{} = sheet, data),
    do: {:ok, Map.merge(sheet, %{sheet: data})}

  defp merge_pid(%Sheet{} = sheet, pid),
    do: {:ok, Map.merge(sheet, %{pid: pid})}

  defp update_refresh_rate(%Sheet{refresh_rate: nil} = sheet),
    do: {:ok, Map.merge(sheet, %{refresh_rate: refresh_rate()})}

  defp update_refresh_rate(%Sheet{} = sheet),
    do: {:ok, sheet}

  defp refresh_rate,
    do: Application.get_env(:spreadsheets, :refresh_rate, @default_refresh_rate)

  defp client,
    do: Application.get_env(:spreadsheets, :client, Google)
end
