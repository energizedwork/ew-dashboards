ExUnit.start()

unless System.get_env("DATABASE_URL") do
  Mix.Task.run "ecto.create", ["--quiet"]
end

Mix.Task.run "ecto.migrate", ["--quiet"]
