defmodule HavenPower.Repo do

  # require HavenPower.Account

  @moduledoc """
  In memory Repository
  """

  def get(module, id) do
    Enum.find all(module), fn map -> map.account_id == id end
  end

  def get_by(module, params) do
    Enum.find all(module), fn map ->
      Enum.all?(params, fn {key, val} -> Map.get(map, key) == val end)
    end
  end

  def all(HavenPower.Account) do
    [%HavenPower.Account{account_id: 1, name: "Gus", data: ["foo", "bar"]},
     %HavenPower.Account{account_id: 2, name: "Matt", data: ["baz", "bing"]}
    ]
  end
  def all(_module), do: []
end
