defmodule Spreadsheets.Client do
  @callback get_spreadsheet(spreadsheet :: %{required(:name) => String.t}) :: {:ok, pid :: Pid}
  @callback fetch_data(spreadsheet :: %{required(:pid) => Pid.t, required(:rows) => Integer.t, required(:cols) => Integer.t}) :: {:ok, spreadsheet :: List}

  @moduledoc """

  Client module is the behaviour interface for speadsheet clients. Both functions take a map so
  any params unique to the client API can be passed without adjusting the behaviour.

  Example Implentation:

  ``` elixir
  def Spreadsheets.Client.Google do
    @behaviour Spreadsheets.Client

    def get_spreadsheet(%{name: name}) do
      # Use name to retrieve a reference to the spreadsheet
    end

    def fetch_data(%{pid: pid, rows: rows, cols: cols}) do
      # Uses the reference pid, number of rows/cols to retrieve data
    end
  end
  ```

  """

end
