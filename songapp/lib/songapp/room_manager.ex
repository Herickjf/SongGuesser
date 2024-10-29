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
        if room.password != password do
          {:error, "Incorrect password"}
        else
          case Game.create_player(%{
                 nickname: nickname,
                 photo_id: photo_id,
                 game_id: room.id,
                 score: 0,
                 status: "waiting"
               }) do
            {:ok, player} ->
              {:ok, player, room}

            {:error, _reason} ->
              {:error, "Failed to join room"}
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

        Process.send_after(self(), {:end_round, socket, room.id}, 30_000)

        {:ok, room}

      {:error, _reason} ->
        {:error, "Failed to update room"}
    end
  end

  def end_round(socket, room) do
    is_end_round =
      if room.current_round_number == room.max_rounds do
        true
      else
        false
      end

    case Game.update_room(room, %{
           status:
             if is_end_round do
               "end"
             else
               "waiting"
             end
         }) do
      {:ok, room} ->
        players = Game.list_players_in_room(room.id)

        for player <- players do
          [guess | _l] =
            Game.list_guesses_by_filters(
              player_id: player.id,
              game_id: room.id,
              round_number: room.current_round_number
            )

          result =
            SongsApi.verificar_palavra_na_letra(guess.artist, guess.song_name, room.round_word)

          IO.inspect(result, label: "result verify word")

          Game.update_guess(guess, %{
            is_correct: result.accepted
          })

          case Game.update_player(player, %{
                 status: "waiting",
                 score:
                   if result.accepted do
                     player.score + 10
                   else
                     player.score - 1
                   end
               }) do
            {:ok, player} ->
              {:ok, player, room}

            {:error, _reason} ->
              IO.puts("Failed to update player")
          end
        end

        romm = Game.get_room(room.id)
        players = Game.list_players_in_room(room.id)

        guesses =
          Game.list_guesses_by_game_and_round(
            game_id: room.id,
            round_number: room.current_round_number
          )

        guesses_json =
          guesses
          |> Enum.map(SongappWeb.RoomChannel.guess_to_map() / 1)
          |> Jason.encode!()

        room_json = Jason.encode!(SongappWeb.RoomChannel.room_to_map(room))

        players_json =
          players
          |> Enum.map(SongappWeb.RoomChannel.player_to_map() / 1)
          |> Jason.encode!()

        broadcast!(socket, "game", %{room: room_json})
        broadcast!(socket, "players", %{players: players_json})
        broadcast!(socket, "guesses", %{guesses: guesses_json})

        {:ok, room, players, guesses}

      {:error, _reason} ->
        {:error, "Failed to update room"}
    end
  end

  def select_music(room, player, artist, song_name) do
    Game.delete_guesses_by_filters(room.id, player.id, room.current_round_number)

    Game.create_guess(%{
      artist: artist,
      song_name: song_name,
      is_correct: nil,
      player_id: player.id,
      game_id: room.id,
      round_number: room.current_round_number,
      selected_music_id: nil
    })

    {:ok, "Music selected"}
  end
end
