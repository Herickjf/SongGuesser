defmodule SongappWeb.PageController do
  use SongappWeb, :controller

  def roomstest(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :roomsTest, layout: false)
  end

#   def index(conn, _params) do
#     render(conn, :index, layout: false)
#   end

#   def about(conn, _params) do
#     render(conn, :about, layout: false)
#   end

#   def howToPlay(conn, _params) do
#     render(conn, :howToPlay, layout: false)
#   end

# def gameScreen(conn, _params) do
#     render(conn, :gameScreen, layout: false)
#   end

def homePhoenix(conn, _params) do
    render(conn, :homePhoenix, layout: false)
  end

end
