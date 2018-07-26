defmodule KyozoStoreWeb.Api.V1.Box.BoxView do
  use KyozoStoreWeb, :view
  alias KyozoStoreWeb.Api.V1.Box.BoxView

  def render("index.json", %{box: box}) do
    %{data: render_many(box, BoxView, "box.json")}
  end

  def render("show.json", %{box: box}) do
    %{data: render_one(box, BoxView, "box.json")}
  end

  def render("box.json", %{box: box}) do
    %{id: box.id,
      tag: box.tag,
      name: box.name,
      short_description: box.short_description,
      description_html: box.description_html,
      username: box.username,
      description_markdown: box.description_markdown,
      private: box.private,
      current_version: box.current_version,
      versions: box.versions}
  end
end
