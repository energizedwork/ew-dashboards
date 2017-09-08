defmodule Spreadsheets.Data.Sheet do
  use GenServer

  @moduledoc """

  Data Sheet for storing spreadsheet data.

  """

  alias Spreadsheets.{
    Data,
    Data.Logic.Sheet
  }

  require Logger

  defstruct name: nil, pid: nil, refresh_rate: nil, sheet: %{}, rows: 10, cols: 5

  def start_link(%Data.Sheet{name: name} = opts),
    do: GenServer.start_link(__MODULE__, opts, name: :"#{name}")

  def init(opts) do
    send(self(), :populate)
    {:ok, opts}
  end

  def cell(name, row, col),
    do: GenServer.call(:"#{name}", {:cell, row, col})

  def all(name),
    do: GenServer.call(:"#{name}", :all)

  def handle_info(:populate, state) do
    case logic().retrieve_data(state) do
      {:ok, state} ->
        Process.send_after(self(), :refresh, state.refresh_rate)
        {:noreply, state}
      {:error, reason} ->
        Logger.error("Error populating sheet #{state.name}: #{inspect reason}")
        {:noreply, state}
    end
  end

  def handle_info(:refresh, state) do
    case logic().retrieve_data(state) do
      {:ok, state} ->
        Process.send_after(self(), :refresh, state.refresh_rate)
        {:noreply, state}
      {:error, reason} ->
        Logger.error("Error refreshing sheet #{state.name}: #{inspect reason}")
        {:noreply, state}
    end
  end

  def handle_info({:DOWN, _pref, :process, _pid, _reason}, state) do
    {:noreply, state}
  end

  def handle_call({:cell, row, col}, _from, state),
    do: {:reply, logic().cell(state, row, col), state}

  def handle_call(:all, _from, state),
    do: {:reply, logic().all(state), state}

  def logic do
    Application.get_env(:spreadsheets, :sheet_logic, Sheet)
  end

end
