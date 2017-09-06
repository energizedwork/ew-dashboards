defmodule Core.Schemas.DataSourceTest do
  use Core.DataCase

  @valid_attrs %{name: "Google Spreadsheet: Monthly"}

  alias Core.Schemas.DataSource

  test "changeset with valid attrs" do
    changeset = DataSource.changeset(%DataSource{}, @valid_attrs)

    assert changeset.valid?
  end

  test "changeset missing required fields" do
    changeset = DataSource.changeset(%DataSource{}, %{})

    refute changeset.valid?
    assert changeset.errors == [
      name: {"can't be blank", [validation: :required]}
    ]
  end

  test "prevent unique constraint violation" do
    %DataSource{}
    |> DataSource.changeset(@valid_attrs)
    |> Repo.insert

    {:error, changeset} = %DataSource{}
    |> DataSource.changeset(@valid_attrs)
    |> Repo.insert

    assert changeset.errors == [data_source: {"already exists", []}]
  end
end
