defmodule Spotify.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  # def start(_type, _args) do
  #   # List all child processes to be supervised
  #   children = [
  #     # Starts a worker by calling: Spotify.Worker.start_link(arg)
  #     # {Spotify.Worker, arg},
  #   ]
  #
  #   # See https://hexdocs.pm/elixir/Supervisor.html
  #   # for other strategies and supported options
  #   opts = [strategy: :one_for_one, name: Spotify.Supervisor]
  #   Supervisor.start_link(children, opts)
  # end

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      supervisor(Registry, [:unique, :spotify_process_registry]),
      supervisor(Spotify.ArtistSupervisor, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Spotify.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
