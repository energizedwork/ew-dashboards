defmodule Core.Schemas.DashboardWidgetTest do
  use Core.DataCase

  alias Core.Schemas.DashboardWidget

  import Core.DataHelper

  setup do
    author = generate_author()
    widget = generate_widget(author)
    dashboard = generate_dashboard(author)

    {:ok, [widget: widget, dashboard: dashboard]}
  end

  test "changeset with valid attrs", %{widget: widget, dashboard: dashboard} do
    attrs = %{dashboard_id: dashboard.id, widget_id: widget.id}
    changeset = DashboardWidget.changeset(%DashboardWidget{}, attrs)
    assert changeset.valid?
  end

  test "changeset missing required fields" do
    changeset = DashboardWidget.changeset(%DashboardWidget{}, %{})

    refute changeset.valid?
    assert changeset.errors == [
      dashboard_id: {"can't be blank", [validation: :required]},
      widget_id: {"can't be blank", [validation: :required]},
    ]
  end

  test "prevent unique constraint violation", %{dashboard: dashboard, widget: widget} do
    attrs = %{dashboard_id: dashboard.id, widget_id: widget.id}

    %DashboardWidget{}
    |> DashboardWidget.changeset(attrs)
    |> Repo.insert

    {:error, changeset} = %DashboardWidget{}
    |> DashboardWidget.changeset(attrs)
    |> Repo.insert

    assert changeset.errors == [dashboard_widget: {"already exists", []}]
  end
end
