defmodule Spotify.Artist do
  @moduledoc """
  Simple genserver to represent an imaginary artist process.

  Requires you provide an integer-based `artist_id` upon starting.

  There is a `:fetch_data` callback handler where you could easily get additional artist attributes
  from a database or some other source - assuming the `artist_id` provided was a valid key to use as
  database criteria.
  """

  use GenServer
  require Logger

  @artist_registry_name :spotify_process_registry
  @process_lifetime_ms 86_400_000 # 24 hours in milliseconds - make this number shorter to experiement with process termination

  # Just a simple struct to manage the state for this genserver
  # You could add additional attributes here to keep track of for a given artist
  defstruct artist_id: 0,
            name: "",
            some_attribute: "",
            widgets_ordered: 1,
            timer_ref: nil


  @doc """
  Starts a new artist process for a given `artist_id`.
  """
  def start_link(artist_id) when is_integer(artist_id) do
    IO.puts "Artist.start_link(#{artist_id})----------->"
    GenServer.start_link(__MODULE__, [artist_id], name: via_tuple(artist_id))
  end


  # registry lookup handler
  defp via_tuple(artist_id), do: {:via, Registry, {@artist_registry_name, artist_id}}


  @doc """
  Return some details (state) for this artist process
  """
  def details(artist_id) do
    GenServer.call(via_tuple(artist_id), :get_details)
  end


  @doc """
  Return the number of widgets ordered by this artist
  """
  def widgets_ordered(artist_id) do
    GenServer.call(via_tuple(artist_id), :get_widgets_ordered)
  end


  @doc """
  Function to indicate that this artist ordered a widget
  """
  def order_widget(artist_id) do
    GenServer.call(via_tuple(artist_id), :order_widget)
  end


  @doc """
  Returns the pid for the `artist_id` stored in the registry
  """
  def whereis(artist_id) do
    case Registry.lookup(@artist_registry_name, artist_id) do
      [{pid, _}] -> pid
      [] -> nil
    end
  end


  @doc """
  Init callback
  """
  def init([artist_id]) do

    # Add a msg to the process mailbox to
    # tell this process to run `:fetch_data`
    send(self(), :fetch_data)
    send(self(), :set_terminate_timer)

    IO.puts("Process created... Artist ID: #{artist_id}")

    # Set initial state and return from `init`
    {:ok, %__MODULE__{ artist_id: artist_id }}
  end


  @doc """
  Our imaginary callback handler to get some data from a DB to
  update the state on this process.
  """
  def handle_info(:fetch_data, state) do

    # update the state from the DB in imaginary land. Hardcoded for now.
    updated_state =
      %__MODULE__{ state | widgets_ordered: 1, name: "Artist foo" }
      # %__MODULE__{ state | widgets_ordered: 1, name: "Artist #{artist_id}" }

    {:noreply, updated_state}
  end

  @doc """
  Callback handler that sets a timer for 24 hours to terminate this process.

  You can call this more than once it will continue to `push out` the timer (and cleans up the previous one)

  I could have combined the logic below and used just one callback handler, but I like seperating the
  concern of creating an initial timer reference versus destroying an existing one. But that is up to you.
  """
  def handle_info(:set_terminate_timer, %__MODULE__{ timer_ref: nil } = state) do
    # This is the first time we've dealt with this artist, so lets set our timer reference attribute
    # to end this process in 24 hours from now

    # set a timer for 24 hours from now to end this process
    updated_state =
      %__MODULE__{ state | timer_ref: Process.send_after(self(), :end_process, @process_lifetime_ms) }

    {:noreply, updated_state}
  end

  def handle_info(:set_terminate_timer, %__MODULE__{ timer_ref: timer_ref } = state) do
    # This match indicates we are in a situation where `state.timer_ref` is not nil -
    # so we already have dealt with this artist before

    # let's cancel the existing timer
    timer_ref |> Process.cancel_timer

    # set a new timer for 24 hours from now to end this process
    updated_state =
      %__MODULE__{ state | timer_ref: Process.send_after(self(), :end_process, @process_lifetime_ms) }

    {:noreply, updated_state}
  end


  @doc """
  Gracefully end this process
  """
  def handle_info(:end_process, state) do
    Logger.info("Process terminating... Artist ID: #{state.artist_id}")
    {:stop, :normal, state}
  end


  @doc false
  def handle_call(:get_details, _from, state) do

    # maybe you'd want to transform the state a bit...
    response = %{
      id: state.artist_id,
      name: state.name,
      some_attribute: state.some_attribute,
      widgets_ordered: state.widgets_ordered
    }

    {:reply, response, state}
  end


  @doc false
  def handle_call(:get_widgets_ordered, _from, %__MODULE__{ widgets_ordered: widgets_ordered } = state) do
    {:reply, widgets_ordered, state}
  end


  @doc false
  def handle_call(:order_widget, _from, %__MODULE__{ widgets_ordered: widgets_ordered } = state) do
    {:reply, :ok, %__MODULE__{ state | widgets_ordered: widgets_ordered + 1 }}
  end

end
