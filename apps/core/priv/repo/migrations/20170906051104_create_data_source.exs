defmodule Core.Repo.Migrations.CreateDataSource do
  use Ecto.Migration

  def up do
    create table(:data_sources, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :deleted, :boolean
      add :deleted_at, :utc_datetime
      add :meta, :map

      timestamps()
    end

    execute("""
    CREATE UNIQUE INDEX index_unique_active_data_sources_idx
    ON data_sources(name)
    WHERE deleted_at IS NULL;
    """)
  end

  def down do
    drop index(:data_sources, [], name: :index_unique_active_data_sources_idx)
    drop table(:data_sources)
  end
end
