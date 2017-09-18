defmodule ApiWeb.Api.V1.AuthorView do
  use ApiWeb, :view
  use JaSerializer.PhoenixView

  attributes [
    :username,
    :image_src
  ]

end
