defmodule Core.Schemas.DashboardTest do
  use Core.DataCase

  @valid_attrs %{name: "Dashboard 1", slug: "dashboard-1"}

  alias Core.Schemas.Dashboard

  import Core.DataHelper, only: [generate_author: 0]

  setup do
    {:ok, [author: generate_author()]}
  end

  test "changeset with valid attrs", %{author: author} do
    attrs = Map.merge(@valid_attrs, %{author_id: author.id})
    changeset = Dashboard.changeset(%Dashboard{}, attrs)
    assert changeset.valid?
  end

  test "changeset missing required fields" do
    changeset = Dashboard.changeset(%Dashboard{}, %{})

    refute changeset.valid?
    assert changeset.errors == [
      name: {"can't be blank", [validation: :required]},
      slug: {"can't be blank", [validation: :required]},
      author_id: {"can't be blank", [validation: :required]}
    ]
  end

  test "prevent unique constraint violation", %{author: author} do
    attrs = Map.merge(@valid_attrs, %{author_id: author.id})

    %Dashboard{}
    |> Dashboard.changeset(attrs)
    |> Repo.insert

    {:error, changeset} = %Dashboard{}
    |> Dashboard.changeset(attrs)
    |> Repo.insert

    assert changeset.errors == [dashboard: {"already exists", []}]
  end
end
