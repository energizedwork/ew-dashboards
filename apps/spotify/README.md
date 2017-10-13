# Spotify

Application to look and hold state from the Spotify API.

One process will be created per artist lookup.

```elixir

iex()> artist_id = 303606909
iex()> Spotify.ArtistSupervisor.find_or_create_process(artist_id)
iex()> Spotify.Artist.details(artist_id)

```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `spotify` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:spotify, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/spotify](https://hexdocs.pm/spotify).
