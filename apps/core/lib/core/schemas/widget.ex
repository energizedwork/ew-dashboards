defmodule Core.Schemas.Widget do
  use Core.Schemas

  @moduledoc """

  Schema for a Widget. There is a JSONB column that allows for
  meta data about the data source.

  """

  alias Core.Schemas.{
    Author,
    WidgetDataSource,
    DashboardWidget
  }

  @unique_index :index_unique_active_widgets_idx
  @unique_error "already exists"

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "widgets" do
    field :name, :string
    field :description, :string
    field :meta, :map

    field :adapter, :string
    field :renderer, :string

    field :deleted, :boolean, default: false
    field :deleted_at, :utc_datetime

    belongs_to :author, Author, type: Ecto.UUID

    has_many :widget_data_sources, WidgetDataSource, on_delete: :delete_all, on_replace: :delete
    has_many :data_sources, through: [:widget_data_sources, :data_source]

    has_many :dashboard_widgets, DashboardWidget, on_delete: :delete_all, on_replace: :delete
    has_many :dashboards, through: [:dashboard_widgets, :dashboard]

    timestamps type: :utc_datetime
  end

  @required_fields ~w(name author_id)a
  @optional_fields ~w(
    description
    meta
    adapter
    renderer
    deleted
    deleted_at
  )a

  def changeset(model, params \\ %{})

  def changeset(model, %{"widget_data_sources" => data_sources} = params) when is_list(data_sources) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:author_id)
    |> unique_constraint(:widget, name: @unique_index, message: @unique_error)
    |> cast_assoc(:widget_data_sources, data_sources)
  end

  def changeset(model, params) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:author_id)
    |> unique_constraint(:widget, name: @unique_index, message: @unique_error)
  end
end
