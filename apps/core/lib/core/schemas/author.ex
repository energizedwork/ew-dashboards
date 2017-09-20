defmodule Core.Schemas.Author do
  use Core.Schemas

  @moduledoc """

  Schema for a Author. Required fields are only username.

  """

  @unique_index :index_unique_active_authors_idx

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "authors" do
    field :username, :string
    field :image_src, :string

    field :deleted, :boolean, default: false
    field :deleted_at, :utc_datetime

    timestamps type: :utc_datetime
  end

  @required_fields ~w(username)a
  @optional_fields ~w(image_src deleted deleted_at)a

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:username, name: @unique_index)
  end
end
