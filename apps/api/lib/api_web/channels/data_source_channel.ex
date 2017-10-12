defmodule ApiWeb.DataSourceChannel do
  use Phoenix.Channel
  require Logger

  @doc """
  Authorize socket to subscribe and broadcast events on this channel & topic

  Possible Return Values

  `{:ok, socket}` to authorize subscription for channel for requested topic

  `:ignore` to deny subscription/broadcast on this channel
  for the requested topic
  """
  def join("dataSource:sheets", message, socket) do
    Process.flag(:trap_exit, true)
    :timer.send_interval(5000, :ping)
    send(self, {:after_join, message})

    {:ok, socket}
  end

  def join("dataSource:" <> _private_subtopic, _message, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_info({:after_join, msg}, socket) do
    broadcast! socket, "user:entered", %{user: msg["user"]}
    push socket, "join", %{status: "connected"}
    {:noreply, socket}
  end

  def handle_info(:ping, socket) do
    rows = String.to_integer(System.get_env("GOOGLE_SHEET_NUM_ROWS") || "4")
    cols = String.to_integer(System.get_env("GOOGLE_SHEET_NUM_COLS") || "12")

    # TODO error handling etc
    {:ok, pid} = Spreadsheets.Client.Google.get_spreadsheet(%{name: System.get_env("GOOGLE_SHEET_ID")})
    {:ok, spreadsheet} = Spreadsheets.Client.Google.fetch_data(%{pid: pid, rows: rows, cols: cols})

    body = %{"data" => spreadsheet}

    push socket, "new:msg", %{user: "SYSTEM", body: body}

    {:noreply, socket}
  end

  def terminate(reason, _socket) do
    Logger.debug"> leave #{inspect reason}"
    :ok
  end

  def handle_in("new:msg", msg, socket) do
    body =
      %{"data" => [
        ["Jan", "Feb", "Mar"],
        [msg["body"], "200", msg["body"]],
        ["xxx", "yyy", "zzz"]]
      }

    broadcast! socket, "new:msg", %{user: msg["user"], body: body}
    {:reply, {:ok, %{msg: msg["body"]}}, assign(socket, :user, msg["user"])}
  end
end
