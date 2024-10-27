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
end
