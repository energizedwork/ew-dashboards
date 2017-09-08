defmodule Core.Schemas.DataSource do
  use Core.Schemas

  @moduledoc """

  Schema for a DataSource. Required fields are only name. There is a JSONB column that allows for
  meta data about the data source.

  """

  @unique_index :index_unique_active_data_sources_idx
  @unique_error "already exists"

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "data_sources" do
    field :name, :string
    field :meta, :map
    field :deleted, :boolean, default: false
    field :deleted_at, :utc_datetime

    timestamps type: :utc_datetime
  end

  @required_fields ~w(name)a
  @optional_fields ~w(deleted deleted_at meta)a

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:data_source, name: @unique_index, message: @unique_error)
  end

end
