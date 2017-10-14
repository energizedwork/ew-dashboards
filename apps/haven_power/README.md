# HavenPower

Application to look up and hold state from the Haven Power data sources.

One process will be created per account lookup.

```bash
$ cd apps/haven_power
$ iex -S mix
```

```elixir
iex()> account_id = 987654321
iex()> HavenPower.AccountSupervisor.find_or_create_process(account_id)
iex()> HavenPower.Account.details(account_id)

```
## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `haven_power` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:haven_power, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/haven_power](https://hexdocs.pm/haven_power).
