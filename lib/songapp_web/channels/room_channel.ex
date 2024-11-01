defmodule SongappWeb.RoomChannel do
  use SongappWeb, :channel

  alias Songapp.RoomsManager
  alias Songapp.Game
  alias Songapp.SongsApi

  def player_to_map(%Songapp.Game.Player{} = player) do
    %{
      id: player.id,
      nickname: player.nickname,
      photo_id: player.photo_id,
      score: player.score,
      status: player.status,
      is_admin: player.is_admin
    }
  end

  # Em Songapp.Game.Room
  def room_to_map(room) do
    %{
      id: room.id,
      code: room.code,
      status: room.status,
      language: room.language,
      max_rounds: room.max_rounds,
      max_players: room.max_players,
      current_round_number: room.current_round_number,
      room_word: room.round_word
    }
  end

  def guess_to_map(guess) do
    %{
      id: guess.id,
      artist: guess.artist,
      song_name: guess.song_name,
      is_correct: guess.is_correct,
      player_id: guess.player_id,
      game_id: guess.game_id,
      round_number: guess.round_number,
      selected_music_id: guess.selected_music_id
    }
  end

  @impl true
  def join("room:lobby", _params, socket) do
    # Permitir a entrada no lobby sem verificar senha, já que é um espaço aberto
    {:ok, socket}
  end

  @impl true
  def join(
        "room:" <> room_code,
        %{"password" => password, "nickname" => nickname, "photo_id" => photo_id},
        socket
      ) do
    case RoomsManager.join_room(room_code, password, nickname, photo_id) do
      {:ok, player, players, room} ->
        # Atribuir permanentemente as informações ao socket
        socket = assign(socket, :room, room) |> assign(:player, player)

        # Preparar os dados para serem enviados após o join

        players_json =
          players
          |> Enum.map(&SongappWeb.RoomChannel.player_to_map/1)
          |> Jason.encode!()

        player_json = Jason.encode!(player_to_map(player))
        room_json = Jason.encode!(room_to_map(room))

        # Enviar uma mensagem para o próprio processo após o join
        send(self(), {:after_join, players_json})

        {:ok, %{player: player_json, players: players_json, room: room_json}, socket}

      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end

  # Manipular a mensagem enviada após o join, broadcastando os dados da lista de jogadores
  @impl true
  def handle_info({:after_join, players_json}, socket) do
    broadcast!(socket, "players", %{players: players_json})
    {:noreply, socket}
  end

  def handle_info({:end_round, room, player_socket}, socket) do
    # Chama a função end_round com os parâmetros desejados

    IO.puts("End round ----------------------------------------------")
    # IO.inspect(room, label: "room")
    # IO.inspect(player_socket, label: "player_socket")

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
               "between_rounds"
             end
         }) do
      {:ok, room} ->
        players = Game.list_players_in_room(room.id)

        for player <- players do
          points =
            case Game.list_guesses_by_filters(player.id, room.id, room.current_round_number) do
              [guess | _l] ->
                result =
                  SongsApi.verificar_palavra_na_letra(
                    guess.artist,
                    guess.song_name,
                    room.round_word
                  )

                IO.inspect(result, label: "result verify word")

                # Atribui pontos com base no resultado
                points = if result.accepted, do: 10, else: 0

                # Atualiza o `guess` com o resultado
                Game.update_guess(guess, %{is_correct: result.accepted})
                points

              [] ->
                IO.puts("No guesses found for player #{player.id} in the current round")
                0
            end

          # Atualiza o jogador com a pontuação correta
          case Game.update_player(player, %{
                 status: "between_rounds",
                 score: player.score + points
               }) do
            {:ok, player} ->
              {:ok, player, room}

            {:error, _reason} ->
              IO.puts("Failed to update player")
          end
        end

        romm = Game.get_room_by_code!(room.code)
        players = Game.list_players_in_room(room.id)

        guesses =
          Game.list_guesses_by_game_and_round(
            room.id,
            room.current_round_number
          )

        guesses_json =
          guesses
          |> Enum.map(&SongappWeb.RoomChannel.guess_to_map/1)
          |> Jason.encode!()

        room_json = Jason.encode!(SongappWeb.RoomChannel.room_to_map(room))

        players_json =
          players
          |> Enum.map(&SongappWeb.RoomChannel.player_to_map/1)
          |> Jason.encode!()

        broadcast!(player_socket, "game", %{room: room_json})
        broadcast!(player_socket, "players", %{players: players_json})
        broadcast!(player_socket, "guesses", %{guesses: guesses_json})

        {:ok, room, players, guesses}

      {:error, _reason} ->
        {:error, "Failed to update room"}
    end

    {:noreply, socket}
  end

  @impl true
  def handle_in(
        "create_room",
        %{
          "password" => password,
          "rounds" => rounds,
          "max_players" => max_players,
          "language" => language,
          "nickname" => nickname,
          "photo_id" => photo_id
        },
        socket
      ) do
    case RoomsManager.create_room(%{
           password: password,
           max_rounds: rounds,
           max_players: max_players,
           language: language,
           nickname: nickname,
           photo_id: photo_id
         }) do
      {:error, reason} ->
        {:reply, {:error, reason}, socket}

      {:ok, room} ->
        IO.inspect(room.code, label: "created room ")
        room_json = Jason.encode!(room_to_map(room))
        {:reply, {:ok, %{room_code: room.code, room: room_json}}, socket}
    end
  end

  # Função para enviar mensagens (shout) apenas para a sala correta
  @impl true
  def handle_in("shout", %{"body" => body, "color_id" => color_id }, socket) do
    player = socket.assigns[:player]
    # room = socket.assigns[:room]

    IO.inspect(body, label: "Received shout")

    # Broadcast apenas para usuários na mesma sala
    broadcast!(socket, "shout", %{
      body: body,
      nickname: player.nickname,
      color_id: color_id
    })

    {:noreply, socket}
  end

  @impl true
  def handle_in("next_round_order", _params, socket) do
    case socket.assigns[:player].is_admin do
      true ->
        room = socket.assigns[:room]

        case RoomsManager.next_round(socket, room) do
          {:ok, room} ->
            {:noreply, assign(socket, :room, room)}

          {:error, reason} ->
            {:reply, {:error, reason}, socket}
        end

      false ->
        {:reply, {:error, "You are not the admin"}, socket}
    end
  end

  @impl true
  def handle_in(
        "music_selection",
        %{"artist" => artist, "song_name" => song_name, "music_id" => music_id},
        socket
      ) do
    player_socket = socket.assigns[:player]
    room_socket = socket.assigns[:room]

    room = Game.get_room!(room_socket.id)
    player = Game.get_player!(player_socket.id)

    # Update the player and room stored in the socket
    socket = assign(socket, :player, player) |> assign(:room, room)

    case RoomsManager.select_music(room, player, artist, song_name, music_id) do
      {:ok, guess} ->
        g = guess_to_map(guess)
        guess_json = Jason.encode!(g)
        {:reply, {:ok, %{guess: guess_json}}, socket}

      {:error, reason} ->
        {:reply, {:error, reason}, socket}
    end
  end

  def handle_in("disconnect", _payload, socket) do
    end_connection("disconnect", socket)
    {:noreply, socket}
  end

  @impl true
  def terminate(_reason, socket) do
    end_connection("terminate", socket)
    {:ok, socket}
  end

  def end_connection(reason, socket) do
    player = socket.assigns[:player]
    room = socket.assigns[:room]
    IO.inspect(label: "player getout room")

    # Remove player from the room
    if player do
      Game.delete_player(player)
    end

    if room do
      case Game.list_players_in_room(room.id) do
        [] ->
          Game.delete_room(room)

        [new_admin | _] ->
          Game.update_player(new_admin, %{is_admin: true})
      end
    end

    # Notify other players in the room
    if room do
      players = Game.list_players_in_room(room.id)

      players_json =
        players
        |> Enum.map(&SongappWeb.RoomChannel.player_to_map/1)
        |> Jason.encode!()

      broadcast!(socket, "players", %{players: players_json})
    end

    :ok
    {:noreply, socket}
  end
end
