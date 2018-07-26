defmodule KyozoStoreWeb.Api.V1.Box.Version.VersionView do
  use KyozoStoreWeb, :view
  alias KyozoStoreWeb.Api.V1.Box.Version.VersionView

  def render("index.json", %{version: version}) do
    %{data: render_many(version, VersionView, "version.json")}
  end

  def render("show.json", %{version: version}) do
    %{data: render_one(version, VersionView, "version.json")}
  end

  def render("version.json", %{version: version}) do
    %{id: version.id,
      version: version.version,
      status: version.status,
      description_html: version.description_html,
      description_markdown: version.description_markdown,
      number: version.number,
      release_url: version.release_url,
      revoke_url: version.revoke_url,
      providers: version.providers}
  end
end
