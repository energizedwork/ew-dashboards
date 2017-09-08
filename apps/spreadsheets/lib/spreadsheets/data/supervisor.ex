defmodule Spreadsheets.Data.Supervisor do
  use Supervisor

  @moduledoc """

  Supervisor for the Data Sheets. Each sheet is a transient process.

  """

  def start_link(opts),
    do: Supervisor.start_link(__MODULE__, :ok, opts)

  def init(:ok) do
    children = [
      Spreadsheets.Data.Sheet
    ]

    Supervisor.init(children, strategy: :simple_one_for_one)
  end

  def start_child(spreadsheet),
    do: Supervisor.start_child(__MODULE__, spreadsheet)

end
