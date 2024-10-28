defmodule SongappWeb.RoomChannel do
  use SongappWeb, :channel

  alias Songapp.RoomsManager

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
        {:ok, socket}

      {:error, reason} ->
        {:error, %{reason: reason}}
    end
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
        {:reply, {:ok, %{room_code: room.code}}, socket}
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
      nickname: player.nickname,
    })

    {:noreply, socket}
  end

  @impl true
  def handle_in("next_round_order", _params, socket) do
    case socket.assigns[:player].is_admin do
      true ->
        room = socket.assigns[:room]

        case RoomsManager.next_round_order(room) do
          {:ok, updated_room} ->
            broadcast!(socket, "next_round_order", %{order: updated_room.order})
            {:noreply, assign(socket, :room, updated_room)}

          {:error, reason} ->
            {:reply, {:error, reason}, socket}
        end

        broadcast!(socket, "game", %{})
        {:ok, game: room}

      false ->
        {:reply, {:error, "You are not the admin"}, socket}
    end
    room = socket.assigns[:room]

    # case RoomsManager.next_round_order(room) do
    #   {:ok, updated_room} ->
    #     broadcast!(socket, "next_round_order", %{order: updated_room.order})
    #     {:noreply, assign(socket, :room, updated_room)}

    #   {:error, reason} ->
    #     {:reply, {:error, reason}, socket}
    # end
  end

  @impl true
  def handle_in("music_form", %{"title" => title, "artist" => artist, "album" => album}, socket) do
    player = socket.assigns[:player]
    room = socket.assigns[:room]

    case RoomsManager.submit_music_form(room, player, %{
           title: title,
           artist: artist,
           album: album
         }) do
      {:ok, updated_room} ->
        broadcast!(socket, "music_form", %{
          title: title,
          artist: artist,
          album: album,
          nickname: player.nickname
        })
        {:noreply, assign(socket, :room, updated_room)}

      {:error, reason} ->
        {:reply, {:error, reason}, socket}
    end
  end


  @impl true
  def handle_in("music_selection", %{"music_id" => music_id}, socket) do
    player = socket.assigns[:player]
    room = socket.assigns[:room]

    case RoomsManager.select_music(room, player, music_id) do
      {:ok, updated_room} ->
        broadcast!(socket, "music_selection", %{
          music_id: music_id,
          nickname: player.nickname
        })
        {:noreply, assign(socket, :room, updated_room)}

      {:error, reason} ->
        {:reply, {:error, reason}, socket}
    end
  end

end
