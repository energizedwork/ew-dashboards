defmodule Core.Schemas do
  @moduledoc """
  This is a class for grouping together common functionality for schemas.
  """

  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
    end
  end
end
