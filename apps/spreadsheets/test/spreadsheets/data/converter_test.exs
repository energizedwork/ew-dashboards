defmodule Spreadsheets.Data.ConverterTest do
  use ExUnit.Case

  alias Spreadsheets.Data.Converter

  @map %{0 => "00", 1 => "01"}
  @list ["00", "01"]

  test "from_list/1 converts a list into a map" do
    assert {:ok, @map} = Converter.from_list(@list)
  end

  test "from_list/1 returns an error on invalid type" do
    assert {:error, "Provide a List to convert to Map."} = Converter.from_list(%{})
  end

  test "from_list/1 returns an empyt Map when the List is empty" do
    assert {:ok, %{}} = Converter.from_list([])
  end

  test "to_list/1 converts a map into a list" do
    assert {:ok, @list} = Converter.to_list(@map)
  end

  test "to_list/1 returns an error on invlaid type" do
    assert {:error, "Provide a Map to convert to List."} = Converter.to_list([])
  end

  test "to_list/1 returns an empyt List when the Map is empty" do
    assert {:ok, []} = Converter.to_list(%{})
  end
end
