defmodule Core.Repo.Migrations.CreateDashboards do
  use Ecto.Migration

  def up do
    create table(:dashboards, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :slug, :string, null: false
      add :description, :text, limit: 1_000

      add :deleted, :boolean
      add :deleted_at, :utc_datetime
      add :meta, :map

      add :author_id, references(:authors, on_delete: :nothing, type: :uuid), null: false

      timestamps()
    end

    create index(:dashboards, [:author_id])

    execute("""
    CREATE UNIQUE INDEX index_unique_active_dashboards_idx
    ON dashboards(name)
    WHERE deleted_at IS NULL;
    """)
  end

  def down do
    drop index(:dashboards, [], name: :index_unique_active_dashboards_idx)
    drop index(:dashboards, [:author_id])
    drop table(:dashboards)
  end
end
