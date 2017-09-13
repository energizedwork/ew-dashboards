defmodule Core.Schemas.AuthorTest do
  use Core.DataCase

  @valid_attrs %{username: "bob-dobbs"}

  alias Core.Schemas.Author

  test "changeset with valid attrs" do
    changeset = Author.changeset(%Author{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset missing required fields" do
    changeset = Author.changeset(%Author{}, %{})

    refute changeset.valid?
    assert changeset.errors == [
      username: {"can't be blank", [validation: :required]}
    ]
  end

  test "prevent unique constraint violation" do
    %Author{}
    |> Author.changeset(@valid_attrs)
    |> Repo.insert

    {:error, changeset} = %Author{}
    |> Author.changeset(@valid_attrs)
    |> Repo.insert

    assert changeset.errors == [author: {"already exists", []}]
  end
end
