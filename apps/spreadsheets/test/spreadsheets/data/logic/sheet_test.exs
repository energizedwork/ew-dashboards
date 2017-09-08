defmodule Spreadsheets.Data.Logic.SheetTest do
  use ExUnit.Case

  alias Spreadsheets.{
    Data,
    Data.Logic.Sheet
  }

  @valid_map %{
    0 => %{0 => "00", 1 => "11", 2 => "22"},
    1 => %{0 => "01", 1 => "12", 2 => "23"}
  }

  setup do
    Application.put_env(:spreadsheets, :refresh_rate, 10_000)
    Application.put_env(:spreadsheets, :client, FakeClient)

    on_exit fn() ->
      Application.delete_env(:spreadsheets, :refresh_rate)
      Application.delete_env(:spreadsheets, :client)
    end
  end

  test "return a populated %Sheet{} struct" do
    {:ok, sheet} = Sheet.retrieve_data(%Data.Sheet{name: "test", rows: 2, cols: 3})
    assert %Data.Sheet{} = sheet
    assert @valid_map = sheet.sheet
  end

  test "does not update refresh rate if one is provided" do
    sheet = %Data.Sheet{name: "test", rows: 2, cols: 3, refresh_rate: 30_000}
    assert {:ok, sheet} = Sheet.retrieve_data(sheet)
    assert 30_000 = sheet.refresh_rate
  end

  test "return the value in a cell" do
    assert "01" = Sheet.cell(%Data.Sheet{sheet: @valid_map}, 1, 0)
  end

  test "return all the values from a sheet" do
    assert @valid_map = Sheet.all(%Data.Sheet{sheet: @valid_map})
  end

end

defmodule FakeClient do
  @behaviour Spreadsheets.Client

  @data [
    ["00", "11", "22"],
    ["01", "12", "23"]
  ]

  def get_spreadsheet(%{name: "test"}) do
    {:ok, self()}
  end

  def fetch_data(%{pid: pid, rows: 2, cols: 3}) when is_pid(pid) do
    {:ok, @data}
  end
end
