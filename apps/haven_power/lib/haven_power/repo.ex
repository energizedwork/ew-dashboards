defmodule HavenPower.Repo do
  @moduledoc """
  In memory Repository
  """

  def get(module, id) do
    account = Enum.find all(module), fn map -> map.account_id == id end

    case account do
      nil -> defaultAccount
      _ -> account
    end

  end

  def get_by(module, params) do
    Enum.find all(module), fn map ->
      Enum.all?(params, fn {key, val} -> Map.get(map, key) == val end)
    end
  end

  def all(HavenPower.Account) do
    [%HavenPower.Account{account_id: 1, name: "Gus", data: [["Apr", "May", "Jun"], ["4", "5", "6"]]},
     %HavenPower.Account{account_id: 2, name: "Matt", data: [["Jan", "Feb", "Mar"], ["1", "2", "3"]]},
     %HavenPower.Account{account_id: 998877, name: "UI Widget", data: random_data()}
    ]
  end
  def all(_module), do: []


  def random_data do
    now =
      Timex.parse!("Wed, 18 Oct 2017 00:00:00 Z", "{RFC1123z}")

    maxDays =
      365

    maxTime =
      48

    maxValue =
      1230

    readingFrequencyMins =
      30

    headers =
      0..maxDays

    randomReadings =
      Enum.reduce(1..maxTime, [],
        fn(_x, acc) ->
          Enum.concat([
            Enum.map(
              Enum.take_random(1..maxValue, maxDays),
              &Kernel.to_string/1
            )
          ], acc)
        end
      )

    body =
      randomReadings
      |> Enum.with_index
      |> Enum.map(
          fn{row, index} ->
            datetime = Timex.shift(now, [minutes: index * readingFrequencyMins])
            {:ok, y_axis_label} = Timex.format(datetime, "{h24}:{m}")

            Enum.concat([y_axis_label], row)
          end
      )

    Enum.concat(
      [Enum.map(headers, &Kernel.to_string/1)],
      body
    )
  end

  defp defaultAccount do
     %HavenPower.Account{account_id: -1, name: "Default Account", data: [["This", "Is", "Default", "Data"], ["1", "2", "3", "4"]]}
  end
end
