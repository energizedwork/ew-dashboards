defmodule Core.Data.DashboardTest do
  use Core.DataCase

  @valid_attrs %{"name" => "Dashboard 1", "slug" => "dashboard-1"}

  import Core.DataHelper, only: [generate_author: 0, generate_widget: 1]

  setup do
    author = generate_author()
    widget = generate_widget(author)
    {:ok, [author: author, widget: widget]}
  end

  alias Core.Data.Dashboard

  test "get an dashboard by id", %{author: author, widget: widget} do
    attrs = Map.merge(@valid_attrs, %{"author_id" => author.id, "dashboard_widgets" => [%{"widget_id" => widget.id}]} )
    assert {:ok, dashboard} = Dashboard.upsert(attrs)
    assert {:ok, dashboard} == Dashboard.get(dashboard.id)
  end

  test "create a new dashboard with valid params", %{author: author, widget: widget} do
    assert [] = Dashboard.all()
    attrs = Map.merge(@valid_attrs, %{"author_id" => author.id, "dashboard_widgets" => [%{"widget_id" => widget.id}]} )
    assert {:ok, dashboard} = Dashboard.upsert(attrs)
    assert dashboard.widgets
    assert [dashboard] == Dashboard.all()
  end

  test "edit an existing dashboard with valid params", %{author: author, widget: widget} do
    assert [] = Dashboard.all()
    attrs = Map.merge(@valid_attrs, %{"author_id" => author.id})
    assert {:ok, dashboard} = Dashboard.upsert(attrs)
    refute dashboard.image_src
    assert {:ok, updated} = Dashboard.upsert(%{"id" => dashboard.id, "description" => "Updated description"})
    assert updated.id == dashboard.id
    assert updated.description == "Updated description"
    assert [updated] == Dashboard.all()
  end

  test "delete an existing dashboard" do
    {:ok, dashboard} = Dashboard.upsert(%{"username" => "bob-dobbs"})
    refute dashboard.deleted
    refute dashboard.deleted_at
    assert :ok = Dashboard.delete(dashboard.id)
    assert [] = Dashboard.all()
  end

  test "get an dashboard with bad id" do
    assert {:error, "Invalid :binary_id with value \"1\""} = Dashboard.delete("1")
  end

  test "delete an dashboard with bad id" do
    assert {:error, "Invalid :binary_id with value \"1\""} = Dashboard.delete("1")
  end
end
