defmodule KyozoStoreWeb.Api.V1.Box.Version.Provider.ProviderView do
  use KyozoStoreWeb, :view
  alias KyozoStoreWeb.Api.V1.Box.Version.Provider.ProviderView

  def render("index.json", %{provider: provider}) do
    %{data: render_many(provider, ProviderView, "provider.json")}
  end

  def render("show.json", %{provider: provider}) do
    %{data: render_one(provider, ProviderView, "provider.json")}
  end

  def render("provider.json", %{provider: provider}) do
    %{id: provider.id,
      name: provider.name,
      hosted: provider.hosted,
      hosted_token: provider.hosted_token,
      original_url: provider.original_url,
      download_url: provider.download_url}
  end
end
