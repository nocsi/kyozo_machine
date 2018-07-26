defmodule KyozoStoreWeb.Api.V1.VersionController do
  use KyozoStoreWeb, :controller
  alias KyozoStore.Org

  action_fallback KyozoStoreWeb.FallbackController

  def create(conn, %{"username" => username, "box_id" => box_id, "version" => version_params}) do
    box = Org.get_box!(username, box_id)
    with {:ok, version} <- Org.create_version(version_params) do
      Org.put_box_version(box, version)
      json conn, version
    end
  end

  def show(conn, %{"username" => username, "box_id" => box_id, "id" => version_id}) do
    version = Org.get_box!(username, box_id)
    |> Org.get_version!(version_id)
    json conn, version
  end

  def update(conn, %{"username" => username, "box_id" => box_id, "id" => version_id, "version" => version_params}) do
    box = Org.get_box!(username, box_id)
    version = Org.get_version!(box, version_id)
    |> IO.inspect
    with new_version <- Org.update_version(version, version_params) do
      Org.update_box_version(box, version, new_version)
      new_version = Ecto.Changeset.apply_changes(new_version)
      json conn, new_version
    end
  end

  def delete(conn, %{"username" => username, "box_id" => box_id, "id" => version_id}) do
    box = Org.get_box!(username, box_id)
    version = Org.get_version!(box, version_id)
    with {:ok, version} <- Org.delete_version(box, version) do
      json conn, version
    end
  end
end
