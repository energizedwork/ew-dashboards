# Data Store

Application to look up and hold state from the Google Sheets.

One process will be created per lookup.

This application is run independently of the api project. This allows the application to run
on a separate node.

Starting the application:

1. First navigate to the application's directory and export the credentials

```bash
$ cd apps/data_store
$ mix deps.get
$ export GCP_CREDENTIALS="$(< /path/to/service_account.json)" # see Google Auth Setup below
```

2. Start with `iex --sname data -S mix`
3. From this iex session you can test by running the following:

```
iex(data@HULK)1> GenServer.call(DataStore.Receiver, {:get, spreadsheet_id, :google_spreadsheet, %{sheet_name: "Sheet1", range: "A1:L7"}})

# inspect running processes as you retrieve sheets
# (view Data Store application and click on PIDs to view their state)
iex(data@HULK)2> :observer.start

```

To connect from another node, i.e. the api application:

1. Start the data store application like above.
2. Navigate to the api's directory

```bash
$ cd apps/api
$ mix deps.get
```

3. Start with `iex --sname api -S mix` or `iex --sname api -S mix phx.server`
4. From this iex session you can test by running the following:

```
iex(api@HULK)4> GenServer.call({DataStore.Receiver, :"data@HULK"}, {:get, spreadsheet_id, :google_spreadsheet, %{sheet_name: "Sheet1", range: "A1:L7"}})

```

## Google Auth Setup
1. Use [this](https://console.developers.google.com/start/api?id=sheets.googleapis.com) wizard to create or select a project in the Google Developers Console and automatically turn on the API. Click __Continue__, then __Go to credentials__.
2. On the __Add credentials to your project page__, create __Service account key__.
3. Select your project name as service account and __JSON__ as key format, download the created key and rename it to __service_account.json__.
4. Press __Manage service accounts__ on a credential page, copy your __Service Account Identifier__: _[projectname]@[domain].iam.gserviceaccount.com_
5. Create or open existing __Google Spreadsheet document__ on your __Google Drive__ and add __Service Account Identifier__ as user invited in spreadsheet's __Collaboration Settings__.
