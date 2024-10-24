defmodule Songapp.RoomsManager do
  alias Songapp.Game

  def create_room(params) do

IO.inspect(params)
    case Game.create_room(%{
           code: Integer.to_string(:rand.uniform(100_000)),
           status: "waiting",
           password: params[:password],
           max_players: params[:max_players],
           language: params[:language],
           player_admin_id: params[:player_admin_id],
           current_round_number: 0,
           round_word: nil,
           max_rounds: params[:max_rounds]
         }) do
      {:ok, room} ->
        {:ok, room.code}

      {:error, changeset} ->
        # Extrair os erros e retorná-los de forma amigável
        errors = Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->

          # Formata as mensagens de erro
          Enum.reduce(opts, msg, fn {key, value}, acc -> String.replace(acc, "%{#{key}}", to_string(value)) end)
        end)

        {:error, %{errors: errors}}
    end
  end


  def join_room(room_code, password, nickname, photo_id) do
    case Game.get_room_by_code!(room_code) do
      nil ->
        {:error, "Room not found on database"}

      room ->
        case Game.create_player(%{
               nickname: nickname,
               photo_id: photo_id,
               game_id: room.id,
               score: 0,
               status: "waiting"
             }) do
          {:ok, player} ->
            IO.inspect(player, label: "Player")
            IO.inspect(room, label: "Room")
            {:ok, player, room}

          {:error, _reason} ->
            {:error, "Failed to join room"}
        end
    end
  end


#   def gen_room_code() do
#     # Gera um código de sala aleatório
#     code = :rand.uniform(1_000_000)

#     # Verifica se esse codigo já existe
#     # Se existir, gera outro, rescursivamente
#     if Songapp.Game.get_room_by_code!(code) == nil do
#       code
#     else
#       gen_room_code()
#     end
#   end
end
