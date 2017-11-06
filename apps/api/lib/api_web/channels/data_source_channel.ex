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
    :timer.send_interval(5000, :ping_from_google)
    send(self(), {:after_join, message})

    {:ok, socket}
  end

  def join("dataSource:sheets:" <> sheet_id, message, socket) do
    Logger.debug "***************************************************"
    Logger.debug "Joined with sheet_id: #{sheet_id}"

    socket = assign(socket, :sheet_id, sheet_id)

    Process.flag(:trap_exit, true)
    :timer.send_interval(5000, :ping_from_google)
    send(self(), {:after_join, message})

    {:ok, socket}
  end

  def join("dataSource:haven:" <> account_id, message, socket) do
    Logger.debug "***************************************************"
    Logger.debug "Joined with account_id: #{account_id}"

    socket = assign(socket, :account_id, account_id)

    Process.flag(:trap_exit, true)
    :timer.send_interval(5000, :ping_from_haven)
    send(self(), {:after_join, message})

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

  def handle_info(:ping_from_google, socket) do
    rows = String.to_integer(System.get_env("GOOGLE_SHEET_NUM_ROWS") || "4")
    cols = String.to_integer(System.get_env("GOOGLE_SHEET_NUM_COLS") || "12")

    sheet_id = socket.assigns[:sheet_id]
    Logger.debug "Getting details for sheet: #{sheet_id}"

    # TODO error handling etc
    {:ok, pid} = Spreadsheets.Client.Google.get_spreadsheet(%{name: sheet_id})
    {:ok, spreadsheet} = Spreadsheets.Client.Google.fetch_data(%{pid: pid, rows: rows, cols: cols})

    body = %{"data" => spreadsheet}

    push socket, "new:msg", %{user: "SYSTEM", uuid: (to_string sheet_id), body: body}

    {:noreply, socket}
  end

  def handle_info(:ping_from_haven, socket) do

    account_id = socket.assigns[:account_id] |> String.to_integer
    Logger.debug "Getting details for account: #{account_id}"

    HavenPower.AccountSupervisor.find_or_create_process(account_id)
    account = HavenPower.Account.details(account_id)

    body = %{"data" => account.data}

    push socket, "new:msg", %{user: "SYSTEM", uuid: (to_string account_id), body: body}

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
