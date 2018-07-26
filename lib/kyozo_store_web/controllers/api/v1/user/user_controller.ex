defmodule KyozoStoreWeb.Api.V1.UserController do
  use KyozoStoreWeb, :controller
  alias KyozoStore.Authenticate.Guardian.Plug
  alias KyozoStore.Org
  alias KyozoStore.Org.User

  action_fallback KyozoStoreWeb.FallbackController

  def index(conn, _params) do
    user = Org.list_user()
    render(conn, "index.json", user: user)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Org.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_v1_user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"username" => username}) do
    user = %User{}
    user = Org.get_user!(username)
    json conn, user
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Org.get_user!(id)

    with {:ok, %User{} = user} <- Org.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Org.get_user!(id)
    with {:ok, %User{}} <- Org.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end