defmodule KyozoStoreWeb.Api.V1.BoxController do
  use KyozoStoreWeb, :controller
  alias KyozoStore.Org
  alias KyozoStore.Org.User.Box

  action_fallback KyozoStoreWeb.FallbackController

  def create(conn, %{"box" => box_params}) do
    with {:ok, %Box{} = box} <- Org.create_box(box_params) do
      json conn, box
    end
  end

  def show(conn, %{"username" => username, "id" => id}) do
    box = Org.get_box!(username, id)
    json conn, box
  end

  def update(conn, %{"username" => username, "id" => id, "box" => box_params}) do
    box = Org.get_box!(username, id)
    with {:ok, %Box{} = box} <- Org.update_box(box, box_params) do
      json conn, box
    end
  end

  def delete(conn, %{"username" => username, "id" => id}) do
    box = Org.get_box!(username, id)
    with {:ok, %Box{}} <- Org.delete_box(box) do
      json conn, box
    end
  end
end
