defmodule KyozoStoreWeb.Api.V1.User.UserControllerTest do
  use KyozoStoreWeb.ConnCase

  alias KyozoStore.Org
  alias KyozoStore.Org.User

  @create_attrs %{avatar_url: "some avatar_url", boxes: [], profile_html: "some profile_html", profile_markdown: "some profile_markdown", username: "some username"}
  @update_attrs %{avatar_url: "some updated avatar_url", boxes: [], profile_html: "some updated profile_html", profile_markdown: "some updated profile_markdown", username: "some updated username"}
  @invalid_attrs %{avatar_url: nil, boxes: nil, profile_html: nil, profile_markdown: nil, username: nil}

  def fixture(:user) do
    {:ok, user} = Org.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all user", %{conn: conn} do
      conn = get conn, api/v1/user_user_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post conn, api/v1/user_user_path(conn, :create), user: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, api/v1/user_user_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "avatar_url" => "some avatar_url",
        "boxes" => [],
        "profile_html" => "some profile_html",
        "profile_markdown" => "some profile_markdown",
        "username" => "some username"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api/v1/user_user_path(conn, :create), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put conn, api/v1/user_user_path(conn, :update, user), user: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, api/v1/user_user_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "avatar_url" => "some updated avatar_url",
        "boxes" => [],
        "profile_html" => "some updated profile_html",
        "profile_markdown" => "some updated profile_markdown",
        "username" => "some updated username"}
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put conn, api/v1/user_user_path(conn, :update, user), user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete conn, api/v1/user_user_path(conn, :delete, user)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, api/v1/user_user_path(conn, :show, user)
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
