defmodule KyozoStoreWeb.Api.V1.Box.BoxControllerTest do
  use KyozoStoreWeb.ConnCase

  alias KyozoStore.Org
  alias KyozoStore.Org.User.Box

  @create_attrs %{current_version: %{}, description_html: "some description_html", description_markdown: "some description_markdown", name: "some name", private: true, short_description: "some short_description", tag: "some tag", username: "some username", versions: []}
  @update_attrs %{current_version: %{}, description_html: "some updated description_html", description_markdown: "some updated description_markdown", name: "some updated name", private: false, short_description: "some updated short_description", tag: "some updated tag", username: "some updated username", versions: []}
  @invalid_attrs %{current_version: nil, description_html: nil, description_markdown: nil, name: nil, private: nil, short_description: nil, tag: nil, username: nil, versions: nil}

  def fixture(:box) do
    {:ok, box} = Org.create_box(@create_attrs)
    box
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all box", %{conn: conn} do
      conn = get conn, api/v1/box_box_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create box" do
    test "renders box when data is valid", %{conn: conn} do
      conn = post conn, api/v1/box_box_path(conn, :create), box: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, api/v1/box_box_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "current_version" => %{},
        "description_html" => "some description_html",
        "description_markdown" => "some description_markdown",
        "name" => "some name",
        "private" => true,
        "short_description" => "some short_description",
        "tag" => "some tag",
        "username" => "some username",
        "versions" => []}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api/v1/box_box_path(conn, :create), box: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update box" do
    setup [:create_box]

    test "renders box when data is valid", %{conn: conn, box: %Box{id: id} = box} do
      conn = put conn, api/v1/box_box_path(conn, :update, box), box: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, api/v1/box_box_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "current_version" => %{},
        "description_html" => "some updated description_html",
        "description_markdown" => "some updated description_markdown",
        "name" => "some updated name",
        "private" => false,
        "short_description" => "some updated short_description",
        "tag" => "some updated tag",
        "username" => "some updated username",
        "versions" => []}
    end

    test "renders errors when data is invalid", %{conn: conn, box: box} do
      conn = put conn, api/v1/box_box_path(conn, :update, box), box: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete box" do
    setup [:create_box]

    test "deletes chosen box", %{conn: conn, box: box} do
      conn = delete conn, api/v1/box_box_path(conn, :delete, box)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, api/v1/box_box_path(conn, :show, box)
      end
    end
  end

  defp create_box(_) do
    box = fixture(:box)
    {:ok, box: box}
  end
end
