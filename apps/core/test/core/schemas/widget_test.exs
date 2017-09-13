defmodule Core.Schemas.WidgetTest do
  use Core.DataCase

  @valid_attrs %{name: "Widget 1"}

  alias Core.Schemas.Widget

  import Core.DataHelper, only: [generate_author: 0]

  setup do
    {:ok, [author: generate_author()]}
  end

  test "changeset with valid attrs", %{author: author} do
    attrs = Map.merge(@valid_attrs, %{author_id: author.id})
    changeset = Widget.changeset(%Widget{}, attrs)
    assert changeset.valid?
  end

  test "changeset missing required fields" do
    changeset = Widget.changeset(%Widget{}, %{})

    refute changeset.valid?
    assert changeset.errors == [
      name: {"can't be blank", [validation: :required]},
      author_id: {"can't be blank", [validation: :required]}
    ]
  end

  test "prevent unique constraint violation", %{author: author} do
    attrs = Map.merge(@valid_attrs, %{author_id: author.id})

    %Widget{}
    |> Widget.changeset(attrs)
    |> Repo.insert

    {:error, changeset} = %Widget{}
    |> Widget.changeset(attrs)
    |> Repo.insert

    assert changeset.errors == [widget: {"already exists", []}]
  end
end
