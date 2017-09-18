defmodule ApiWeb.Api.V1.DashboardView do
  use ApiWeb, :view
  use JaSerializer.PhoenixView

  attributes [
    :name,
    :slug,
    :description,
    :meta
  ]

  has_one :author,
    serializer: ApiWeb.Api.V1.AuthorView,
    include: true

  has_many :widgets,
    serializer: ApiWeb.Api.V1.WidgetView,
    include: true

end
