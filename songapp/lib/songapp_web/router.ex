defmodule SongappWeb.Router do
  use SongappWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SongappWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug CORSPlug, origin: "*"  # Habilita CORS para qualquer origem
  end

  scope "/", SongappWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/index", PageController, :index
    get "/about", PageController, :about
    get "/howToPlay", PageController, :howToPlay
  end


  scope "/api", SongappWeb do
    pipe_through :api
    post "/search", PageController, :search
    post "/validate", PageController, :validate
    post "/getWord", PageController, :getWord
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:songapp, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SongappWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
