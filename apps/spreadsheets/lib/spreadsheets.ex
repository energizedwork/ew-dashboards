defmodule Spreadsheets.Data.Supervisor do
  use Supervisor

  @moduledoc """

  Supervisor for the Data Matrix processes

  """

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      Spreadsheets.Data.Matrix
    ]

    Supervisor.init(children, strategy: :simple_one_for_one)
  end

  def start_child(spreadsheet) do
    Supervisor.start_child(__MODULE__, spreadsheet)
  end

end

defmodule Spreadsheets.Data.Matrix do
  use GenServer

  @moduledoc """

  Data Matrix for storing spreadsheet data

  """

  alias Spreadsheets.Data.Matrix

  defstruct name: nil, pid: nil, refresh_rate: nil, matrix: %{}, rows: 10, cols: 5

  def start_link(%Matrix{name: name} = opts) do
    GenServer.start_link(__MODULE__, opts, name: :"#{name}")
  end

  def init(opts) do
    send(self(), :populate)
    {:ok, opts}
  end

  def get_cell(name, row, col) do
    GenServer.call(:"#{name}", {:cell, row, col})
  end

  def get_all(name) do
    GenServer.call(:"#{name}", :all)
  end

  def handle_info(:populate, state) do
    with {:ok, pid} <- client().get_spreadsheet(state),
         {:ok, state} <- merge_pid(state, pid),
         {:ok, state} <- update_refresh_rate(state),
         {:ok, state} <- client().fetch_data(state) do

      Process.send_after(self(), :refresh, state.refresh_rate)

      {:noreply, state}
    else
      error ->
        {:noreply, error}
    end
  end

  def handle_info(:refresh, state) do
    with {:ok, pid} <- client().get_spreadsheet(state),
         {:ok, state} <- merge_pid(state, pid),
         {:ok, state} <- client().fetch_data(state) do

      Process.send_after(self(), :refresh, state.refresh_rate)

      {:noreply, state}
    else
      error ->
        {:noreply, error}
    end

    {:noreply, state}
  end

  def handle_call({:cell, row, col}, _from, state) do
    {:reply, state.matrix[row][col], state}
  end

  def handle_call(:all, _from, state) do
    {:reply, state.matrix, state}
  end

  defp merge_pid(state, pid) do
    {:ok, Map.merge(state, %{pid: pid})}
  end

  defp update_refresh_rate(%{refresh_rate: nil} = state) do
    {:ok, Map.merge(state, %{refresh_rate: refresh_rate()})}
  end

  defp update_refresh_rate(state), do: state

  defp refresh_rate do
    Application.get_env(:spreadsheets, :refresh_rate, 30_000)
  end

  defp client do
    Application.get_env(:spreadsheets, :client, Spreadsheets.Google.Client)
  end

end

defmodule Spreadsheets.Google.Client do
  @callback get_spreadsheet(spreadsheet :: Map) :: {:ok, pid :: Pid}
  @callback fetch_data(spreadsheet :: Map) :: {:ok, }

  @moduledoc """

  Client module for communicating with Google spreadsheets

  """

  @spec get_spreadsheet(spreadsheet :: Map) :: {:ok, pid :: Pid}
  def get_spreadsheet(%{name: name}) do
    GSS.Spreadsheet.Supervisor.spreadsheet(name)
  end

  @spec fetch_data(spreadsheet :: Map) :: {:ok, spreadsheet :: Map}
  def fetch_data(%{pid: pid, rows: rows, cols: cols} = matrix) do
    {:ok, data} = 1..rows
    |> Enum.map(&(&1))
    |> read_rows(cols, pid)

    data = Spreadsheets.MatrixConverter.from_list(data)

    {:ok, Map.merge(matrix, %{matrix: data})}
  end

  defp read_rows(rows, cols, pid) do
    GSS.Spreadsheet.read_rows(pid, rows, column_to: cols, pad_empty: true)
  end

end

defmodule Spreadsheets.MatrixConverter do

  @moduledoc """

  Used to convert between Lists and Maps

  """

  @spec from_list(list :: List) :: results :: Map
  def from_list(list) when is_list(list) do
    do_from_list(list)
  end

  @spec to_list(map :: Map) :: results :: List
  def to_list(matrix) when is_map(matrix) do
    do_to_list(matrix)
  end

  defp do_from_list(list, map \\ %{}, index \\ 0)
  defp do_from_list([], map, _index), do: map
  defp do_from_list([h|t], map, index) do
    map = Map.put(map, index, do_from_list(h))
    do_from_list(t, map, index + 1)
  end
  defp do_from_list(other, _, _), do: other

  defp do_to_list(matrix) when is_map(matrix) do
    for {_index, value} <- matrix,
      into: [],
      do: do_to_list(value)
  end
  defp do_to_list(other), do: other
end
