defmodule ApiWeb.ErrorView do
  use ApiWeb, :view

  use JaSerializer.PhoenixView

  def render("404.json-api", _assigns) do
    %{errors: [%{status: "404", detail: "Not found"}]}
  end

  def render("500.json-api", _assigns) do
    %{errors: [%{status: "500", detail: "Internal server error"}]}
  end

  def template_not_found(template_name, _assigns) do
    [status | _] = String.split(template_name, ".")
    %{errors: [%{status: status}]}
  end
end
