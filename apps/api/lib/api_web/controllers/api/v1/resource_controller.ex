defmodule ApiWeb.Api.V1.ResourceController do
  use ApiWeb, :controller

  action_fallback ApiWeb.Api.V1.FallbackController

  def action(%{params: %{"type" => type}} = conn, _opts) do
    params = conn.params["data"] || conn.params

    with {:ok, handler} <- handler_for(type),
         {:ok, view_module} <- view_for(type) do

      conn = put_view(conn, view_module)
      apply(__MODULE__, action_name(conn), [conn, params, handler])
    end
  end

  #
  # API Calls
  #

  @doc """
  Returns a list of resources
  """
  def index(conn, _params, handler) do
    render(conn, data: handler.all())
  end

  @doc """
  Returns a single resource
  """
  def show(conn, %{"id" => id}, handler) do
    with {:ok, resource} when resource != nil <- handler.get(id) do
      render(conn, data: resource)
    end
  end

  @doc """
  Creates a resource and returns it
  """
  def create(conn, params, handler) do
    params = JaSerializer.Params.to_attributes(params)
    with {:ok, new} <- handler.upsert(params) do
      conn
      |> put_status(:created)
      |> render(:show, data: new)
    end
  end

  @doc """
  Returns an updated resource
  """
  def update(conn, %{"id" => id} = params, handler) do
    params = params
    |> JaSerializer.Params.to_attributes()
    |> Map.put_new("id", id)

    with {:ok, resource} <- handler.upsert(params) do
      render(conn, :show, data: resource)
    end
  end

  @doc """
  Returns a list of resources following a deletion
  """
  def delete(conn, %{"id" => id}, handler) do
    with :ok <- handler.delete(id) do
      send_resp(conn, :no_content, "")
    end
  end

  #
  #  UTILS
  #
  defp handler_for("authors"), do: {:ok, Application.get_env(:core, :author_mod, Core.Data.Author)}
  defp handler_for("widgets"), do: {:ok, Application.get_env(:core, :widget_mod, Core.Data.Widget)}
  defp handler_for("dashboards"), do: {:ok, Application.get_env(:core, :dashboard_mod, Core.Data.Dashboard)}
  defp handler_for("datasources"), do: {:ok, Application.get_env(:core, :datasource_mod, Core.Data.DataSource)}
  defp handler_for(_), do: {:error, :no_handler}

  defp view_for("authors"), do: {:ok, ApiWeb.Api.V1.AuthorView}
  defp view_for("widgets"), do: {:ok, ApiWeb.Api.V1.WidgetView}
  defp view_for("dashboards"), do: {:ok, ApiWeb.Api.V1.DashboardView}
  defp view_for("datasources"), do: {:ok, ApiWeb.Api.V1.DataSourceView}
  defp view_for(_), do: {:error, :no_view_module}

end
