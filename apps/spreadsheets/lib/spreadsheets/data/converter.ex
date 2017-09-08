defmodule Spreadsheets.Data.Converter do

  @moduledoc """

  Used to convert between Lists and Maps

  """

  @spec from_list(list :: List) :: {:ok, Map.t} :: {:error, String.t}
  def from_list(list) when is_list(list),
    do: {:ok, build_map(list)}

  def from_list(_list),
    do: {:error, "Provide a List to convert to Map."}

  @spec to_list(map :: Map) :: {:ok, List.t} :: {:error, String.t}
  def to_list(map) when is_map(map),
    do: {:ok, build_list(map)}

  def to_list(_map),
    do: {:error, "Provide a Map to convert to List."}

  defp build_map(list, map \\ %{}, index \\ 0)

  defp build_map([], map, _index),
    do: map

  defp build_map([h|t], map, index) do
    map = Map.put(map, index, build_map(h))
    build_map(t, map, index + 1)
  end

  defp build_map(other, _, _),
    do: other

  defp build_list(map) when is_map(map) do
    for {_index, value} <- map,
      into: [],
      do: build_list(value)
  end

  defp build_list(other),
    do: other
end
