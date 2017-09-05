defmodule Spreadsheets.Client.GoogleTest do
  use ExUnit.Case

  alias Spreadsheets.Client.Google, as: Client

  setup do
    Application.put_env(:spreadsheets, :google_client, FakeGoogleSpreadsheets)
    Application.put_env(:spreadsheets, :google_client_supervisor, FakeGoogleSpreadsheets.Supervisor)

    on_exit fn() ->
      Application.delete_env(:spreadsheets, :google_client)
      Application.delete_env(:spreadsheets, :google_client_supervisor)
    end
  end

  test "returns `{:ok, pid}` when requesting spreadsheet" do
    assert {:ok, pid} = Client.get_spreadsheet(%{name: "1"})
    assert is_pid(pid)
  end

  test "returns {:ok, data} when requesting data using a pid" do
    assert {:ok, pid} = Client.get_spreadsheet(%{name: "1"})
    assert {:ok, data} = Client.fetch_data(%{pid: pid, rows: 2, cols: 3})

    assert is_list(data)
    assert 2 = Enum.count(data)
    assert ["00", "11", "22"] = List.first(data)
    assert ["01", "12", "23"] = List.last(data)
  end
end

defmodule FakeGoogleSpreadsheets do

  @data [
    ["00", "11", "22"],
    ["01", "12", "23"]
  ]

  defmodule Supervisor do
    def spreadsheet("1") do
      {:ok, self()}
    end
  end

  def read_rows(pid, [1, 2], column_to: 3, pad_empty: true) when is_pid(pid) do
    {:ok, @data}
  end
end
