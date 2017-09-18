defmodule Core.Schemas.DashboardWidget do
  use Core.Schemas

  @moduledoc """

  Schema for a Dashboard Widgets.

  """

  alias Core.Schemas.{
    Dashboard,
    Widget
  }

  @unique_index :index_unique_dashboard_widget_idx
  @unique_error "already exists"

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "dashboard_widgets" do

    belongs_to :dashboard, Dashboard, type: Ecto.UUID
    belongs_to :widget, Widget, type: Ecto.UUID

    timestamps type: :utc_datetime
  end

  @required_fields ~w(dashboard_id widget_id)a

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:dashboard_widget, name: @unique_index, message: @unique_error)
  end
end
