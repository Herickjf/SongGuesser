defmodule Songapp.RoomsManager do
  alias Songapp.Rooms.Game

  def create_room(params) do

    Game.create_game(%{

      code: :rand.uniform(1_000_000),
      password: params[:password],
      rounds: params[:rounds],
      max_players: params[:max_players],
      language: params[:language],
      date: :erlang.system_time(:second),
      player_admin_id: params[:player_admin_id]
    })

  end

  def join_room(room_code, password, nickname, photo_id) do
    
  end
end
