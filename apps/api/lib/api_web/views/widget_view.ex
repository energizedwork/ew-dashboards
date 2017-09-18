defmodule ApiWeb.Api.V1.WidgetView do
  use ApiWeb, :view
  use JaSerializer.PhoenixView

  attributes [
    :name,
    :description,
    :adapter,
    :renderer,
    :meta
  ]

  has_one :author,
    serializer: ApiWeb.Api.V1.AuthorView,
    include: true

  has_many :data_sources,
    serializer: ApiWeb.Api.V1.DataSourceView,
    include: true

end
