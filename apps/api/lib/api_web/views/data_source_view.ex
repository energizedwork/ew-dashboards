defmodule ApiWeb.Api.V1.DataSourceView do
  use ApiWeb, :view
  use JaSerializer.PhoenixView

  attributes [
    :name,
    :meta
  ]

end
