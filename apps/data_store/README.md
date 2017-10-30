# DataStore

Application to look up and hold state from the Google Sheets.

One process will be created per lookup.

```bash
$ cd apps/data_store
$ mix deps.get
$ export GCP_CREDENTIALS="$(< /path/to/service_account.json)" # see Google Auth Setup below
$ iex -S mix
```

```elixir
# retrieving sheets
iex()> sheet_id = "1P0okW7oVus2KR423Ob1DgbVNCbR_QNg3OjNPj04zcsI"
iex()> query = %{sheet_name: "Sheet1", range: "A1:L7"}

iex()> GoogleSpreadsheet.Supervisor.start_data_source(sheet_id, query)
iex()> GoogleSpreadsheet.data(sheet_id)

# inspect running processes as you retrieve sheets
# (view Data Store application and click on PIDs to view their state)
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

## Google Auth Setup
1. Use [this](https://console.developers.google.com/start/api?id=sheets.googleapis.com) wizard to create or select a project in the Google Developers Console and automatically turn on the API. Click __Continue__, then __Go to credentials__.
2. On the __Add credentials to your project page__, create __Service account key__.
3. Select your project name as service account and __JSON__ as key format, download the created key and rename it to __service_account.json__.
4. Press __Manage service accounts__ on a credential page, copy your __Service Account Identifier__: _[projectname]@[domain].iam.gserviceaccount.com_
5. Create or open existing __Google Spreadsheet document__ on your __Google Drive__ and add __Service Account Identifier__ as user invited in spreadsheet's __Collaboration Settings__.
