defmodule Core.Repo.Migrations.CreateDashboardWidgets do
  use Ecto.Migration

  def change do
    create table(:dashboard_widgets, primary_key: false) do
      add :id, :uuid, primary_key: true

      add :dashboard_id, references(:dashboards, on_delete: :nothing, type: :uuid), null: false
      add :widget_id, references(:widgets, on_delete: :nothing, type: :uuid), null: false

      timestamps()
    end

    create unique_index(:dashboard_widgets, [:dashboard_id, :widget_id])
    create index(:dashboard_widgets, [:dashboard_id])
    create index(:dashboard_widgets, [:widget_id])
  end
end
