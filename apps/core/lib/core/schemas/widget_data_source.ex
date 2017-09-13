defmodule Core.Schemas.WidgetDataSource do
  use Core.Schemas

  @moduledoc """

  Schema for a Widget Data Source.

  """

  alias Core.Schemas.{
    DataSource,
    Widget
  }

  @unique_index :index_unique_widget_data_source_idx
  @unique_error "already exists"

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "widget_data_sources" do

    belongs_to :data_source, DataSource, type: Ecto.UUID
    belongs_to :widget, Widget, type: Ecto.UUID

    timestamps type: :utc_datetime
  end

  @required_fields ~w(data_source_id widget_id)a

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:widget_data_source, name: @unique_index, message: @unique_error)
  end
end
