defmodule Core.Schemas.Dashboard do
  use Core.Schemas

  @moduledoc """

  Schema for a Dashboard. There is a JSONB column that allows for
  meta data about the data source.

  """

  alias Core.Schemas.{
    Author,
    DashboardWidget
  }

  @unique_index :index_unique_active_dashboards_idx
  @unique_error "already exists"

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "dashboards" do
    field :name, :string
    field :slug, :string
    field :description, :string
    field :meta, :map

    field :deleted, :boolean, default: false
    field :deleted_at, :utc_datetime

    belongs_to :author, Author, type: Ecto.UUID

    has_many :dashboard_widgets, DashboardWidget, on_delete: :delete_all, on_replace: :delete
    has_many :widgets, through: [:dashboard_widgets, :widgets]

    timestamps type: :utc_datetime
  end

  @required_fields ~w(name slug author_id)a
  @optional_fields ~w(description deleted deleted_at meta)a

  def changeset(model, params \\ %{})

  def changeset(model, %{"dashboard_widgets" => widgets} = params) when is_list(widgets) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:author_id)
    |> unique_constraint(:dashboard, name: @unique_index, message: @unique_error)
    |> cast_assoc(:dashboard_widgets, params["dashboard_widgets"])
  end

  def changeset(model, params) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:author_id)
    |> unique_constraint(:dashboard, name: @unique_index, message: @unique_error)
  end
end
