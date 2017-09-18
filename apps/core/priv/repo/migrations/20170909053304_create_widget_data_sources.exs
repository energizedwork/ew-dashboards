defmodule Core.Repo.Migrations.CreateWidgetDataSources do
  use Ecto.Migration

  def change do
    create table(:widget_data_sources, primary_key: false) do
      add :id, :uuid, primary_key: true

      add :widget_id, references(:widgets, on_delete: :nothing, type: :uuid), null: false
      add :data_source_id, references(:data_sources, on_delete: :nothing, type: :uuid), null: false

      timestamps()
    end

    create unique_index(:widget_data_sources, [:data_source_id, :widget_id], name: :index_unique_widget_data_source_idx)
    create index(:widget_data_sources, [:widget_id])
    create index(:widget_data_sources, [:data_source_id])
  end
end
