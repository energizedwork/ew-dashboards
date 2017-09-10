defmodule Core.Repo.Migrations.CreateWidgets do
  use Ecto.Migration

  def up do
    create table(:widgets, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :slug, :string
      add :description, :text, limit: 1_000

      add :adaptor, :string, default: "2D"
      add :renderer, :string, default: "TABLE"

      add :deleted, :boolean
      add :deleted_at, :utc_datetime
      add :meta, :map

      add :author_id, references(:authors, on_delete: :nothing, type: :uuid), null: false

      timestamps()
    end

    create index(:widgets, [:author_id])

    execute("""
    CREATE UNIQUE INDEX index_unique_active_widgets_idx
    ON widgets(name)
    WHERE deleted_at IS NULL;
    """)
  end

  def down do
    drop index(:widgets, [], name: :index_unique_active_widgets_idx)
    drop index(:widgets, [:author_id])
    drop table(:widgets)
  end

end
