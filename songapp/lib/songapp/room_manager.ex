defmodule Songapp.RoomsManager do
  use SongappWeb, :channel
  alias Songapp.Game
  alias Songapp.SongsApi

  def create_room(params) do
    IO.inspect(params)

    case Game.create_room(%{
           code: Integer.to_string(:rand.uniform(100_000)),
           status: "waiting",
           password: params[:password],
           max_players: params[:max_players],
           language: params[:language],
           current_round_number: 0,
           round_word: nil,
           max_rounds: params[:max_rounds]
         }) do
      {:ok, room} ->
        {:ok, room}

      {:error, changeset} ->
        # Extrair os erros e retorná-los de forma amigável
        errors =
          Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
            # Formata as mensagens de erro
            Enum.reduce(opts, msg, fn {key, value}, acc ->
              String.replace(acc, "%{#{key}}", to_string(value))
            end)
          end)

        {:error, %{errors: errors}}
    end
  end

  def join_room(room_code, password, nickname, photo_id) do
    case Game.get_room_by_code!(room_code) do
      nil ->
        {:error, "Room not found on database"}

      room ->
        players = Game.list_players_in_room(room.id)

        if room.password != password do
          {:error, "Incorrect password"}
        else
          if length(players) + 1 > room.max_players do
            {:error, "Room is full"}
          else
            case Game.create_player(%{
                   nickname: nickname,
                   photo_id: photo_id,
                   game_id: room.id,
                   score: 0,
                   status: "waiting",
                   is_admin:
                     if Enum.count(players, fn player -> player.is_admin end) == 0 do
                       true
                     else
                       false
                     end
                 }) do
              {:ok, player} ->
                {:ok, player, [player | players], room}

              {:error, _reason} ->
                {:error, "Failed to join room"}
            end
          end
        end
    end
  end

  def next_round(socket, room) do
    word = SongsApi.buscar_palavra_aleatoria(room.language, [room.round_word])

    case Game.update_room(room, %{
           current_round_number: room.current_round_number + 1,
           status: "playing",
           round_word: word
         }) do
      {:ok, room} ->
        room_json = Jason.encode!(SongappWeb.RoomChannel.room_to_map(room))
        broadcast!(socket, "game", %{room: room_json})

        Process.send_after(self(), {:end_round, room, socket}, 15_000)

        {:ok, room}

      {:error, _reason} ->
        {:error, "Failed to update room"}
    end
  end



  def select_music(room, player, artist, song_name, music_id) do
    Game.delete_guesses_by_filters(room.id, player.id, room.current_round_number)

    case Game.create_guess(%{
           artist: artist,
           song_name: song_name,
           is_correct: nil,
           player_id: player.id,
           game_id: room.id,
           round_number: room.current_round_number,
           selected_music_id: music_id,
         }) do
      {:ok, guess} ->
        {:ok, guess}

      {:error, changeset} ->
        errors =
          Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
            Enum.reduce(opts, msg, fn {key, value}, acc ->
              String.replace(acc, "%{#{key}}", to_string(value))
            end)
          end)

        {:error, %{errors: errors}}
    end
  end
end
