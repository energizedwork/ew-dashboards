defmodule ApiWeb.Api.V1.ResourceControllerTest do
  use ApiWeb.ConnCase

  @widgets [
    %{"id" => "1",
      "type" => "widget",
      "attributes" => %{
        "name" => "Test Widget 1",
        "adapter" =>  nil,
        "description" => nil,
        "meta" => nil,
        "renderer" => nil,
      }, "relationships" => %{
        "author" => %{"data" => nil},
        "data-sources" => %{"data" => nil}}
     },
    %{"id" => "2",
      "type" => "widget",
      "attributes" => %{
        "name" => "Test Widget 2",
        "adapter" =>  nil,
        "description" => nil,
        "meta" => nil,
        "renderer" => nil,
      }, "relationships" => %{
        "author" => %{"data" => nil},
        "data-sources" => %{"data" => nil}}
    }
  ]

  setup do
    conn =
      build_conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    Application.put_env(:core, :widget_mod, FakeWidget)

    on_exit fn ->
      Application.delete_env(:core, :widget_mod)
    end

    {:ok, conn: conn}
  end

  test "GET /api/v1/widgets/:id returns a single WIDGET", %{conn: conn} do
    %{"data" => data} = get(conn, api_v1_resource_path(conn, :show, "widgets", 1))
      |> json_response(200)
    assert List.first(@widgets) == data

    %{"data" => data} = get(conn, api_v1_resource_path(conn, :show, "widgets", 2))
      |> json_response(200)
    assert List.last(@widgets) == data
  end

  test "GET /api/v1/widgets/:id returns 404 message when WIDGET doesn't exist", %{conn: conn} do
     get(conn, api_v1_resource_path(conn, :show, "widgets", 3))
      |> json_response(404)
  end

  test "GET /api/v1/widgets returns a list of WIDGETs", %{conn: conn} do
    %{"data" => data} =  get(conn, api_v1_resource_path(conn, :index, "widgets"))
      |> json_response(200)

    assert @widgets = data
  end

  test "POST /api/v1/ create a new WIDGET and returns it", %{conn: conn} do
    params = %{attributes: %{name: "Create Test 1"}, type: "widget"}
    %{"data" => data} = post(conn, api_v1_resource_path(conn, :create, "widgets", %{data: params}))
      |> json_response(201)

    assert data["id"]
    assert data["type"] == "widget"
    assert data["attributes"]["name"] == "Create Test 1"
  end

  test "PATCH /api/v1/ update an existing WIDGET and return single", %{conn: conn} do
    params = %{id: UUID.uuid1(), attributes: %{name: "Update Test 1"}, type: "widget"}
    %{"data" => data} = patch(conn, api_v1_resource_path(conn, :update, "widgets", %{data: params}))
      |> json_response(200)

    assert data["id"]
    assert data["attributes"]["name"] == "Update Test 1"
  end

  test "DELETE /api/v1/widgets/id deletes a WIDGET and returns remaining WIDGETs", %{conn: conn} do
   delete(conn, api_v1_resource_path(conn, :delete, "widgets", 1))
      |> response(204)
  end
end

defmodule FakeWidget do
  @widgets [
    %{id: 1,
      name: "Test Widget 1",
      description: nil,
      adapter: nil,
      renderer: nil,
      meta: nil},
    %{id: 2,
      name: "Test Widget 2",
      description: nil,
      adapter: nil,
      renderer: nil,
      meta: nil}
  ]

  def all(), do: @widgets

  def get("1"),
    do: {:ok, %{id: 1, name: "Test Widget 1"}}

  def get("2"),
    do: {:ok, %{id: 2, name: "Test Widget 2"}}

  def get("3"),
    do: {:ok, nil}

  def upsert(%{"name" => "Create Test 1"} = widget),
    do: {:ok, %{id: UUID.uuid1(), name: widget["name"]}}

  def upsert(%{"name" => "Update Test 1", "id" => id} = widget),
    do: {:ok, %{id: id, name: widget["name"]}}

  def delete("1") do
    :ok
  end

end
