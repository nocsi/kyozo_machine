defmodule KyozoStoreWeb.Router do
  use KyozoStoreWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.Pipeline, module: KyozoStore.Authenticate.Guardian,
                             error_handler: KyozoStore.Authenticate.ErrorHandler
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource, allow_blank: true
  end

  pipeline :token_auth do
    plug :accepts, ["json"]
    plug Guardian.Plug.Pipeline, module: KyozoStore.Authenticate.Guardian,
                             error_handler: KyozoStore.Authenticate.ErrorHandler
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/", KyozoStoreWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", KyozoStoreWeb.Api, as: :api do
    scope "/v1", V1, as: :v1 do
      post "/authenticate", AuthenticateController, :login
      pipe_through [:api]
      get "/authenticate", AuthenticateController, :validate
      pipe_through [:token_auth]
      get "/user/:username", UserController, :show
      post "/boxes", BoxController, :create
      resources "/box/:username", BoxController do
        post "/versions", VersionController, :create
        resources "/version", VersionController do
          post "/providers", ProviderController, :create
          resources "/provider", ProviderController do
            get "/upload", ProviderController, :upload
          end
        end
      end
    end
  end
end
