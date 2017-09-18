defmodule ApiWeb.ErrorViewTest do
  use ApiWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.json" do
    assert render(ApiWeb.ErrorView, "404.json", []) ==
      %{errors: [%{status: "404"}]}
  end

  test "render 500.json" do
    assert render(ApiWeb.ErrorView, "500.json", []) ==
      %{errors: [%{status: "500"}]}
  end

  test "render any other" do
    assert render(ApiWeb.ErrorView, "505.json", []) ==
      %{errors: [%{status: "505"}]}
  end
end
