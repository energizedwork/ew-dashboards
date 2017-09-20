defmodule Core.Data.Widget do
  use Core.Data.Query,
    schema: Core.Schemas.Widget,
    preloads: [:author, :data_sources]
end
