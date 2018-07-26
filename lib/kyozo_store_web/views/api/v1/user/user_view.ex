defmodule KyozoStoreWeb.Api.V1.User.UserView do
  use KyozoStoreWeb, :view
  alias KyozoStoreWeb.Api.V1.User.UserView

  def render("index.json", %{user: user}) do
    %{data: render_many(user, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      username: user.username,
      avatar_url: user.avatar_url,
      profile_html: user.profile_html,
      profile_markdown: user.profile_markdown,
      boxes: user.boxes}
  end
end
