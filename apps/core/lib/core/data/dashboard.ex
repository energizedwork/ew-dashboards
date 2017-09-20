defmodule Core.Data.Dashboard do
  use Core.Data.Query,
    schema: Core.Schemas.Dashboard,
    preloads: [:author]
end
