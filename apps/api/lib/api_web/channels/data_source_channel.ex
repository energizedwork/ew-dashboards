defmodule ApiWeb.DataSourceChannel do
  alias Core.Repo
  alias Core.Schemas.DataSource

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

  def join("dataSource:sheets:" <> data_source_id, message, socket) do
    Logger.debug "*************************************************************"
    Logger.debug "Joined sheets with data_source_id: #{data_source_id}"

    socket = assign(socket, :sheet_data_source, Repo.get(DataSource, data_source_id))

    Process.flag(:trap_exit, true)
    :timer.send_interval(5000, :ping_from_google)
    send(self(), {:after_join, message})

    {:ok, socket}
  end

  def join("dataSource:haven:" <> account_id, message, socket) do
    Logger.debug "*************************************************************"
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
    ds = socket.assigns[:sheet_data_source]
    Logger.debug "Getting details for sheet: #{ds.id}"

    # TODO error handling etc
    spreadsheet =
      GenServer.call(DataStore.Receiver, {:get, ds.meta["sheet_id"], :google_spreadsheet, %{sheet_name: ds.meta["sheet_name"], range: ds.meta["range"]}})

    push socket, "new:msg", %{user: "SYSTEM", uuid: (to_string ds.id), body: %{"data" => spreadsheet["values"]}}

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
