# lib/songapp_web/router.ex
defmodule SongappWeb.Router do
  use SongappWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {SongappWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    # Para aceitar CORS de todas as rotas:
    plug CORSPlug, origin: "*"
  end

  scope "/", SongappWeb do
    pipe_through :browser

    live "/home", HomeLive, :show
    live "/about", AboutLive, :show
    live "/game", GameLive, :show
    live "/how", HowLive, :show
  end

  scope "/test" do
    pipe_through :browser

    get "/home", PageController, :homePhoenix
    get "/rooms", PageController, :roomstest
  end

  # scope "/", SongappWeb do
  #   pipe_through :browser

  #   live "/room", RoomtestLive.Index, :index
  #   live "/room/new", RoomtestLive.Index, :new
  #   live "/room/:id/edit", RoomtestLive.Index, :edit

  #   live "/room/:id", RoomtestLive.Show, :show
  #   live "/room/:id/show/edit", RoomtestLive.Show, :edit
  # end

  # Other scopes may use custom stacks.
  scope "/api", SongappWeb do
    pipe_through :api

    options "/search_song", PageController, :search_song
    post "/search_song", PageController, :search_song
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
