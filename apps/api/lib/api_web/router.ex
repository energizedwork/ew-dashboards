defmodule ApiWeb.Router do
  use ApiWeb, :router

  scope "/api", as: :api, alias: ApiWeb.Api do
    scope "/v1", as: :v1, alias: V1 do
      get "/:type", ResourceController, :index
      get "/:type/:id", ResourceController, :show
      post "/:type", ResourceController, :create
      patch "/:type", ResourceController, :update
      delete "/:type/:id", ResourceController, :delete
    end
  end
end
