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
        {:ok, assign(socket, :room, room) |> assign(:player, player)}

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
          "language" => language
        },
        socket
      ) do
    case RoomsManager.create_room(%{
           password: password,
           max_rounds: rounds,
           max_players: max_players,
           language: language,
           player_admin_id: 0
         }) do
      {:error, reason} ->
IO.inspect(reason)
        {:reply, {:error, reason}, socket}

      {:ok, room_code} ->
        {:reply, {:ok, %{room_code: room_code}}, socket}
    end
  end

 # Função para enviar mensagens (shout) apenas para a sala correta
 @impl true
 def handle_in("shout", %{"body" => body, "room_code" => room_code}, socket) do
  #  player = socket.assigns[:player]
  #  room = socket.assigns[:room]

   # Verifica se o player está atribuído corretamente
  #  if player == nil do
  #    IO.puts("Player not assigned to socket!")
  #  else
  #    IO.inspect(socket.assigns)
  #  end

  #  room_code = room.code

   # Broadcast apenas para usuários na mesma sala (room_code)
   broadcast!(socket, "room:#{room_code}:shout", %{
     body: body,
    #  player: player.nickname  # Inclui o nickname do jogador na mensagem
   })

   {:noreply, socket}
 end
end
