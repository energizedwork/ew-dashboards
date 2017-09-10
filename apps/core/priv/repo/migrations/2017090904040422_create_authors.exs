defmodule Core.Repo.Migrations.CreateAuthors do
  use Ecto.Migration

  def up do
    create table(:authors, primary_key: false) do
      add :id, :uuid, primary_key: true

      add :username, :string
      add :image_src, :string

      add :deleted, :boolean
      add :deleted_at, :utc_datetime

      timestamps()
    end

    execute("""
    CREATE UNIQUE INDEX index_unique_active_authors_idx
    ON authors(username)
    WHERE deleted_at IS NULL;
    """)

  end

  def down do
    drop index(:authors, [], name: :index_unique_active_authors_idx)
    drop table(:authors)
  end
end
