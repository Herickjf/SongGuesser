defmodule SongappWeb.RoomChannel do
  use SongappWeb, :channel

  alias Songapp.RoomsManager
  alias Songapp.Game

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
      current_round_number: room.current_round_number
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
      {:ok, player, room} ->
        # Atribuir permanentemente as informações ao socket
        socket = assign(socket, :room, room) |> assign(:player, player)

        # Preparar os dados para serem enviados após o join
        players = Game.list_players_in_room(room.id)

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
  def handle_info({:after_join, players_json}, socket) do
    broadcast!(socket, "players", %{players: players_json})
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
  def handle_in("shout", %{"body" => body}, socket) do
    player = socket.assigns[:player]
    # room = socket.assigns[:room]

    IO.inspect(body, label: "Received shout")

    # Broadcast apenas para usuários na mesma sala
    broadcast!(socket, "shout", %{
      body: body,
      nickname: player.nickname
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
  def handle_in("music_selection", %{"artist" => artist, "song_name" => song_name}, socket) do
    player = socket.assigns[:player]
    room = socket.assigns[:room]

    case RoomsManager.select_music(room, player, artist, song_name) do
      {:ok, guess} ->
        {:ok, guess}

      {:error, reason} ->
        {:reply, {:error, reason}, socket}
    end
  end

  @impl true
  def terminate(_reason, socket) do
    player = socket.assigns[:player]
    room = socket.assigns[:room]

    # Remove player from the room
    Game.delete_player(player)
    case Game.list_players_in_room(room.id) do
      [] ->
      RoomsManager.delete_room(room)
      [new_admin | _] ->
      Game.update_player(new_admin, %{is_admin: true})
    end
    Game.update_player(player, %{is_admin: true})

    # Notify other players in the room
    players = Game.list_players_in_room(room.id)

    players_json =
      players
      |> Enum.map(&SongappWeb.RoomChannel.player_to_map/1)
      |> Jason.encode!()

    broadcast!(socket, "players", %{players: players_json})

    :ok
  end
end
