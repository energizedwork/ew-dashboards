# DataStore

Application to look up and hold state from the Google Sheets.

One process will be created per lookup.

```bash
$ cd apps/data_store
$ mix deps.get
$ iex -S mix
```

```elixir
# creating sheets
iex()> sheet_id = "1P0okW7oVus2KR423Ob1DgbVNCbR_QNg3OjNPj04zcsI"
iex()> query = %{sheet_name: "Sheet1", range: "A1:L7"}

iex()> GoogleSpreadsheet.Supervisor.start_data_source(sheet_id, query)
iex()> GoogleSpreadsheet.data(sheet_id)

# inspect running processes as you create accounts (view Data Store application and click on PIDs to view their state)

iex()> :observer.start

```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `data_store` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:data_store, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/data_store](https://hexdocs.pm/data_store).
