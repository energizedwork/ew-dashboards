defmodule Spreadsheets.Data.SheetTest do
  use ExUnit.Case

  alias Spreadsheets.Data.Sheet

  import ExUnit.CaptureLog

  @valid_map %{
    0 => %{0 => "00", 1 => "11", 2 => "22"},
    1 => %{0 => "01", 1 => "12", 2 => "23"}
  }

  setup do
    Application.put_env(:spreadsheets, :sheet_logic, FakeSheetLogic)
    {:ok, _pid} = Sheet.start_link(%Sheet{name: "test", refresh_rate: 5_000})

    on_exit fn() ->
      Application.delete_env(:spreadsheets, :sheet_logic)
    end
  end

  test "return value from a cell" do
    assert "00" = Sheet.cell("test", 0, 0)
    assert "01" = Sheet.cell("test", 1, 0)
  end

  test "return all values from sheet" do
    assert @valid_map = Sheet.all("test")
  end

  test "check for errors on populate" do
    fun = fn() ->
      case Sheet.start_link(%Sheet{name: "error_test", refresh_rate: 200}) do
        {:error, _reason} ->
          send(:"error_test", :refresh)
        _ ->
          :timer.sleep(100)
      end
    end
    assert capture_log(fun) =~ "Error populating sheet error_test: \"ugh\""
    assert capture_log(fun) =~ "Error refreshing sheet error_test: \"ugh\""
  end
end

defmodule FakeSheetLogic do
  @behaviour Spreadsheets.Data.Logic.Sheet

  alias Spreadsheets.Data.Sheet

  @valid_map %{
    0 => %{0 => "00", 1 => "11", 2 => "22"},
    1 => %{0 => "01", 1 => "12", 2 => "23"}
  }

  def retrieve_data(%Sheet{name: "test"} = sheet) do
    {:ok, Map.merge(sheet, %{sheet: @valid_map})}
  end

  def retrieve_data(%Sheet{name: "error_test"}) do
    {:error, "ugh"}
  end

  def cell(%Sheet{} = sheet, row, col),
    do: sheet.sheet[row][col]

  def all(%Sheet{} = sheet),
    do: sheet.sheet
end
