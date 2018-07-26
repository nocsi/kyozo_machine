defmodule KyozoStoreWeb.Api.V1.Box.Version.VersionControllerTest do
  use KyozoStoreWeb.ConnCase

  alias KyozoStore.Org
  alias KyozoStore.Org.User.Box.Version

  @create_attrs %{description_html: "some description_html", description_markdown: "some description_markdown", number: "some number", providers: [], release_url: "some release_url", revoke_url: "some revoke_url", status: "some status", version: "some version"}
  @update_attrs %{description_html: "some updated description_html", description_markdown: "some updated description_markdown", number: "some updated number", providers: [], release_url: "some updated release_url", revoke_url: "some updated revoke_url", status: "some updated status", version: "some updated version"}
  @invalid_attrs %{description_html: nil, description_markdown: nil, number: nil, providers: nil, release_url: nil, revoke_url: nil, status: nil, version: nil}

  def fixture(:version) do
    {:ok, version} = Org.create_version(@create_attrs)
    version
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all version", %{conn: conn} do
      conn = get conn, api/v1/box/version_version_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create version" do
    test "renders version when data is valid", %{conn: conn} do
      conn = post conn, api/v1/box/version_version_path(conn, :create), version: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, api/v1/box/version_version_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "description_html" => "some description_html",
        "description_markdown" => "some description_markdown",
        "number" => "some number",
        "providers" => [],
        "release_url" => "some release_url",
        "revoke_url" => "some revoke_url",
        "status" => "some status",
        "version" => "some version"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api/v1/box/version_version_path(conn, :create), version: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update version" do
    setup [:create_version]

    test "renders version when data is valid", %{conn: conn, version: %Version{id: id} = version} do
      conn = put conn, api/v1/box/version_version_path(conn, :update, version), version: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, api/v1/box/version_version_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "description_html" => "some updated description_html",
        "description_markdown" => "some updated description_markdown",
        "number" => "some updated number",
        "providers" => [],
        "release_url" => "some updated release_url",
        "revoke_url" => "some updated revoke_url",
        "status" => "some updated status",
        "version" => "some updated version"}
    end

    test "renders errors when data is invalid", %{conn: conn, version: version} do
      conn = put conn, api/v1/box/version_version_path(conn, :update, version), version: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete version" do
    setup [:create_version]

    test "deletes chosen version", %{conn: conn, version: version} do
      conn = delete conn, api/v1/box/version_version_path(conn, :delete, version)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, api/v1/box/version_version_path(conn, :show, version)
      end
    end
  end

  defp create_version(_) do
    version = fixture(:version)
    {:ok, version: version}
  end
end
