# Haven Power

Application to look up and hold state from the Haven Power data sources.

One process will be created per account lookup.

```bash
$ cd apps/haven_power
$ iex -S mix
```

```elixir
# creating accounts
iex()> account_id = 987654321
iex()> HavenPower.AccountSupervisor.find_or_create_process(account_id)
iex()> HavenPower.Account.details(account_id)

# inspect running processes as you create accounts (view Haven Power application and click on PIDs to view their state)

iex()> :observer.start

# working with the Repo
iex()> alias HavenPower.Repo
iex()> alias HavenPower.Account
iex()> HavenPower.Repo.all(HavenPower.Account)
iex()> HavenPower.Repo.get(HavenPower.Account, 1)


```
Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/haven_power](https://hexdocs.pm/haven_power).
