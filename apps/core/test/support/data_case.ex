defmodule Core.DataCase do
  use ExUnit.CaseTemplate

  alias Ecto.Adapters.SQL.Sandbox

  @moduledoc """

  Common functionality shared by data tests

  """

  using do
    quote do
      alias Core.Repo

      use ExUnit.Case

      import Ecto.Changeset
      import Core.DataCase
    end
  end

  setup _tags do
    Sandbox.checkout(Core.Repo)
    :ok
  end

end
