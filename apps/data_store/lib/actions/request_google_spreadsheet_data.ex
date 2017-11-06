defmodule DataStore.Action.RequestGoogleSpreadsheetData do
  require Logger

  @moduledoc """

  This is the action module to retrieve google spreadsheet data. It takes the
  name/id of the spreadsheet and the query data: sheet_name and col/row range

  Example:

  iex> run("1goNDckM11s023VmhhsuV2Ll3D-f61J2Vv2RLWwcy8q4", %{sheet_name: "Sheet1", range: "A1:B2"})
  %{"majorDimension" => "ROWS", "range" => "Sheet1!A1:B2",
  "values" => [["Column A", "Column B"],
  ["Value A1", "Value B1"],
  ["Value A2", "Value B2"]}

  """

  alias GoogleSpreadsheet.QueryData

  @auth_scope "https://www.googleapis.com/auth/spreadsheets"
  @url "https://sheets.googleapis.com/v4/spreadsheets/"
  @opts [ssl: [{:versions, [:'tlsv1.2']}]]

  def run(spreadsheet_id, %{sheet_name: sheet_name, range: range}) do
    [@url, spreadsheet_id, "/values/", sheet_name, "!", range]
    |> Enum.join()
    |> client().get(headers(), @opts)
    |> case do
         {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
           {:ok, Poison.decode!(body) }
         {:ok, %HTTPoison.Response{status_code: status_code, body: body} = resp } when status_code >= 400 ->
           Logger.error "Error: #{inspect resp}"
           {:error , %{status: status_code, data: nil} }
         {:error, %HTTPoison.Error{reason: reason} = err} ->
           Logger.error "Error 500: #{inspect err}"
           {:error, %{status: 500, data: nil}}
       end
  end

  defp headers do
    {:ok, %{token: token}} = Goth.Token.for_scope(@auth_scope)
    %{"Authorization" => "Bearer #{token}"}
  end

  defp client,
    do: Application.get_env(:data_store, :http_client, DataStore.HttpClient)
end
