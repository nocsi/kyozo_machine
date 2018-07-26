defmodule KyozoStoreWeb.Api.V1.Box.Version.Provider.ProviderControllerTest do
  use KyozoStoreWeb.ConnCase

  alias KyozoStore.Org
  alias KyozoStore.Org.User.Box.Version.Provider

  @create_attrs %{download_url: "some download_url", hosted: true, hosted_token: "some hosted_token", name: "some name", original_url: "some original_url"}
  @update_attrs %{download_url: "some updated download_url", hosted: false, hosted_token: "some updated hosted_token", name: "some updated name", original_url: "some updated original_url"}
  @invalid_attrs %{download_url: nil, hosted: nil, hosted_token: nil, name: nil, original_url: nil}

  def fixture(:provider) do
    {:ok, provider} = Org.create_provider(@create_attrs)
    provider
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all provider", %{conn: conn} do
      conn = get conn, api/v1/box/version/provider_provider_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create provider" do
    test "renders provider when data is valid", %{conn: conn} do
      conn = post conn, api/v1/box/version/provider_provider_path(conn, :create), provider: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, api/v1/box/version/provider_provider_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "download_url" => "some download_url",
        "hosted" => true,
        "hosted_token" => "some hosted_token",
        "name" => "some name",
        "original_url" => "some original_url"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api/v1/box/version/provider_provider_path(conn, :create), provider: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update provider" do
    setup [:create_provider]

    test "renders provider when data is valid", %{conn: conn, provider: %Provider{id: id} = provider} do
      conn = put conn, api/v1/box/version/provider_provider_path(conn, :update, provider), provider: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, api/v1/box/version/provider_provider_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "download_url" => "some updated download_url",
        "hosted" => false,
        "hosted_token" => "some updated hosted_token",
        "name" => "some updated name",
        "original_url" => "some updated original_url"}
    end

    test "renders errors when data is invalid", %{conn: conn, provider: provider} do
      conn = put conn, api/v1/box/version/provider_provider_path(conn, :update, provider), provider: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete provider" do
    setup [:create_provider]

    test "deletes chosen provider", %{conn: conn, provider: provider} do
      conn = delete conn, api/v1/box/version/provider_provider_path(conn, :delete, provider)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, api/v1/box/version/provider_provider_path(conn, :show, provider)
      end
    end
  end

  defp create_provider(_) do
    provider = fixture(:provider)
    {:ok, provider: provider}
  end
end
