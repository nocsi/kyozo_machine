defmodule KyozoStoreWeb.Api.V1.ProviderController do
  use KyozoStoreWeb, :controller

  alias KyozoStore.Org

  action_fallback KyozoStoreWeb.FallbackController

  def create(conn, %{"username" => username, "box_id" => box_id, "version_id" => version_id, "provider" => provider_params}) do
    box = Org.get_box!(username, box_id)
    version = Org.get_version!(box, version_id)
    with {:ok, provider} <- Org.create_provider(provider_params) do
      Org.put_box_provider(box, version, provider)
      json conn, provider
    end
  end

  def show(conn, %{"username" => username, "box_id" => box_id, "version_id" => version_id, "id" => provider_id}) do
    box = Org.get_box!(username, box_id)
    provider = Org.get_provider!(box, version_id, provider_id)
    json conn, provider
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

  def update(conn, %{"username" => username, "box_id" => box_id, "version_id" => version_id, "id" => provider_id, "provider" => provider_params}) do
    box = Org.get_box!(username, box_id)
    version = Org.get_version!(box, version_id)
    provider = Org.get_provider!(box_id, version_id, provider_id)
    |> IO.inspect

    with new_provider <- Org.update_provider(provider, provider_params) do
      Org.update_version_provider(box, version, provider, new_provider)
      new_provider = Ecto.Changeset.apply_changes(new_provider)
      json conn, new_provider
    end
  end

  def delete(conn, %{"username" => username, "box_id" => box_id, "version_id" => version_id, "id" => provider_id}) do
    box = Org.get_box!(username, box_id)
    version = Org.get_version!(box, version_id)
    provider = Org.get_provider!(box, version_id, provider_id)
    with {:ok, provider} <- Org.delete_provider(box, version, provider) do
      json conn, provider
    end
  end

  def upload(conn, %{"username" => username, "box_id" => box_id, "version_id" => version_id, "provider_id" => provider_id}) do
    box = Org.get_box!(username, box_id)
    with {:ok, upload_path} <- Org.upload_provider(box, version_id, provider_id) do 
      json conn, %{"upload_path" => upload_path}
    end
  end
end
