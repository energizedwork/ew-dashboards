defmodule Core.Schemas.WidgetDataSourceTest do
  use Core.DataCase

  alias Core.Schemas.WidgetDataSource

  import Core.DataHelper

  setup do
    author = generate_author()
    widget = generate_widget(author)
    data_source = generate_data_source()

    {:ok, [widget: widget, data_source: data_source]}
  end

  test "changeset with valid attrs", %{widget: widget, data_source: data_source} do
    attrs = %{data_source_id: data_source.id, widget_id: widget.id}
    changeset = WidgetDataSource.changeset(%WidgetDataSource{}, attrs)
    assert changeset.valid?
  end

  test "changeset missing required fields" do
    changeset = WidgetDataSource.changeset(%WidgetDataSource{}, %{})

    refute changeset.valid?
    assert changeset.errors == [
      data_source_id: {"can't be blank", [validation: :required]},
      widget_id: {"can't be blank", [validation: :required]},
    ]
  end

  test "prevent unique constraint violation", %{data_source: data_source, widget: widget} do
    attrs = %{data_source_id: data_source.id, widget_id: widget.id}

    %WidgetDataSource{}
    |> WidgetDataSource.changeset(attrs)
    |> Repo.insert

    {:error, changeset} = %WidgetDataSource{}
    |> WidgetDataSource.changeset(attrs)
    |> Repo.insert

    assert changeset.errors == [widget_data_source: {"already exists", []}]
  end

end
