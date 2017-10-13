defmodule Spotify.ArtistSupervisor do
  @moduledoc """
  Supervisor to handle the creation of dynamic `Spotify.Artist` processes using a
  `simple_one_for_one` strategy. See the `init` callback at the bottom for details on that.

  These processes will spawn for each `artist_id` provided to the
  `Spotify.Artist.start_link` function.

  Functions contained in this supervisor module will assist in the creation and retrieval of
  new artist processes.

  Also note the guards utilizing `is_integer(artist_id)` on the functions. My feeling here is that
  if someone makes a mistake and tries sending a string-based key or an atom, I'll just _"let it crash"_.
  """

  use Supervisor
  require Logger


  @artists_registry_name :spotify_process_registry

  @doc """
  Starts the supervisor.
  """
  def start_link, do: Supervisor.start_link(__MODULE__, [], name: __MODULE__)


  @doc """
  Will find the process identifier (in our case, the `artist_id`) if it exists in the registry and
  is attached to a running `Spotify.Artist` process.

  If the `artist_id` is not present in the registry, it will create a new `Spotify.Artist`
  process and add it to the registry for the given `artist_id`.

  Returns a tuple such as `{:ok, artist_id}` or `{:error, reason}`
  """
  def find_or_create_process(artist_id) when is_integer(artist_id) do
    if artist_process_exists?(artist_id) do
      {:ok, artist_id}
    else
      artist_id |> create_artist_process
    end
  end


  @doc """
  Determines if a `Spotify.Artist` process exists, based on the `artist_id` provided.

  Returns a boolean.

  ## Example
      iex> Spotify.ArtistSupervisor.artist_process_exists?(6)
      false
  """
  def artist_process_exists?(artist_id) when is_integer(artist_id) do
    case Registry.lookup(@artists_registry_name, artist_id) do
      [] -> false
      _ -> true
    end
  end


  @doc """
  Creates a new Artist process, based on the `artist_id` integer.

  Returns a tuple such as `{:ok, artist_id}` if successful.
  If there is an issue, an `{:error, reason}` tuple is returned.
  """
  def create_artist_process(artist_id) when is_integer(artist_id) do
    case Supervisor.start_child(__MODULE__, [artist_id]) do
      {:ok, _pid} -> {:ok, artist_id}
      {:error, {:already_started, _pid}} -> {:error, :process_already_exists}
      other -> {:error, other}
    end
  end


  @doc """
  Returns the count of `Spotify.Artist` processes managed by this supervisor.

  ## Example
      iex> Spotify.ArtistSupervisor.artist_process_count
      0
  """
  def artist_process_count, do: Supervisor.which_children(__MODULE__) |> length


  @doc """
  Return a list of `artist_id` integers known by the registry.

  ex - `[1, 23, 46]`
  """
  def artist_ids do
    Supervisor.which_children(__MODULE__)
    |> Enum.map(fn {_, artist_proc_pid, _, _} ->
      Registry.keys(@artists_registry_name, artist_proc_pid)
      |> List.first
    end)
    |> Enum.sort
  end


  @doc """
  Return a list of widgets ordered per artist.

  The list will be made up of a map structure for each child artist process.

  ex - `[%{artist_id: 2, widgets_sold: 1}, %{artist_id: 10, widgets_sold: 1}]`
  """
  def get_all_artist_widgets_ordered do
    artist_ids() |> Enum.map(&(%{ artist_id: &1, widgets_sold: Spotify.Artist.widgets_ordered(&1) }))
  end


  @doc false
  def init(_) do
    children = [
      worker(Spotify.Artist, [], restart: :temporary)
    ]

    # strategy set to `:simple_one_for_one` to handle dynamic child processes.
    supervise(children, strategy: :simple_one_for_one)
  end

end
