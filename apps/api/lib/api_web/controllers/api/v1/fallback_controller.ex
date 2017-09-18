defmodule ApiWeb.Api.V1.FallbackController do
  use ApiWeb, :controller

  require Logger

  def call(conn, {:error, :no_handler}) do
    Logger.warn("No handler implemented for #{conn.method} #{conn.request_path}")
    not_found(conn)
  end

  def call(conn, {:error, :no_view_module}) do
    Logger.warn("No view module implemented for #{conn.method} #{conn.request_path}")
    conn
    |> put_status(:internal_server_error)
    |> render_errors(%{status: "500", detail: "There is no view module for this route"})
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> render_errors(%{status: "401", detail: "Unauthorized"})
  end

  def call(conn, {:error, reason}) do
    conn
    |> put_status(:bad_request)
    |> render_errors(%{status: "400", detail: reason})
  end

  # Resource was not found
  def call(conn, {:ok, nil}) do
    not_found(conn)
  end

  defp not_found(conn) do
    conn
    |> put_status(:not_found)
    |> render_errors(%{status: "404", detail: "Not Found"})
  end

  defp render_errors(conn, data) do
    conn
    |> put_view(ApiWeb.ErrorView)
    |> render("errors.json-api", data: data)
  end

end
