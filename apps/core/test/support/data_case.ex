defmodule Core.DataCase do
  use ExUnit.CaseTemplate

  alias Ecto.Adapters.SQL.Sandbox

  @moduledoc """

  Common functionality shared by data tests

  """

  defmacro __using__(_opts) do
    quote do
      alias Core.Repo

      use ExUnit.Case

      import Ecto.Changeset
      import Core.DataCase
    end
  end

  setup do
    Sandbox.checkout(Core.Repo)
    Sandbox.mode(Core.Repo, {:shared, self()})
    :ok
  end
end
