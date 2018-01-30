# EW Dashboards

Configure Dashboards and their containing Widgets for consumption by the [Dashboards UI](https://github.com/energizedwork/ew-dashboards-ui).

Define a number of Data Sources that can be made available to the API or via [Phoenix Channels](https://hexdocs.pm/phoenix/channels.html) over web sockets.

This is an umbrella project that contains a number of isolated, executable applications. See the nested READMEs for more info.

- [apps/api](apps/api/README.md)
- [apps/core](apps/core/README.md)
- [apps/tasks](apps/tasks/README.md)
- [apps/data_store](apps/data_store/README.md)
- [apps/haven_power](apps/spreadsheets/README.md)




## Local setup

- Install [Elixir 1.5 (& Erlang)](https://elixir-lang.org/install.html)
- Install [PostgreSQL](https://www.postgresql.org)

```bash
# get src & libs
$ git clone https://github.com/energizedwork/ew-dashboards
$ cd ew-dashboards && mix deps.get

# create and migrate your database
$ mix ecto.create && mix ecto.migrate

# install Node.js?
$ npm install

# start Phoenix API endpoint
$ mix phx.server

# or with a REPL
$ iex -S mix phx.server
```
The API is available at [`localhost:4000`](http://localhost:4000) (not currently used in Prod UI !).

The UI uses the Phoenix Channel at [`ws://localhost:4000/socket/websocket`](ws://localhost:4000/socket/websocket)

## Test / Develop

```bash
# Run all apps tests
$ mix test

# TODO: add guard test runner

```

## CI & Deployment

Heroku based deploys using Heroku CI. Pushes to origin/master will auto deploy on a green test run.

```bash
# deploy master
$ git push origin master
```

```bash
# deploy a branch
$ git remote add staging 	https://git.heroku.com/ew-dashboards-staging.git

$ git push staging my-branch-name:master
```

### DB Seeds (non destructive)

```bash
$ heroku run bash
$ POOL_SIZE=2 mix run apps/api/priv/repo/seeds.exs

# view inserted rows
$ POOL_SIZE=2 iex -S mix

iex()> alias Core.Repo
iex()> alias Core.Schemas.DataSource
iex()> Repo.all DataSource


```
