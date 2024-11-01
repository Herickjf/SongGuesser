defmodule SongappWeb.PageController do
  use SongappWeb, :controller
  alias Songapp.SongsApi

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

  def search_song(conn, params) do
    %{"artist" => artist, "track" => track} = params
    json(conn, SongsApi.buscar_musicas_deezer(artist, track))
  end

  def search_by_id(conn, params) do
    %{"id" => id} = params
    json(conn, SongsApi.buscar_info_musica_deezer(id))
  end

end
