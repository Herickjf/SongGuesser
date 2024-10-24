defmodule SongappWeb.RoomChannel do
  use SongappWeb, :channel

  alias Songapp.RoomsManager

  @impl true
  def join("room:lobby", _params, socket) do
    # Permitir a entrada no lobby sem verificar senha, já que é um espaço aberto
    {:ok, socket}
  end

  @impl true
  def join("room:" <> room_code, %{"password" => password, "nickname" => nickname, "photo_id" => photo_id}, socket) do
    # case RoomsManager.join_room(room_code, password, nickname, photo_id) do
    #   {:ok, room} ->
    #     {:ok, assign(socket, :room, room)}
    #   {:error, reason} ->
    #     {:error, %{reason: reason}}
    # end

      # {:ok, assign(socket, :room, room_code)}
  end

  @impl true
  def handle_in("create_room", %{"password" => password, "rounds" => rounds, "max_players" => max_players, "language" => language}, socket) do
    IO.puts("Socket ID do admim: #{socket.id}")
    room_code = RoomsManager.create_room(%{
      password: password,
      rounds: rounds,
      max_players: max_players,
      language: language,
      player_admin_id: socket.id
    })

    # Responder para o cliente com o código da sala
    {:reply, {:ok, %{room_code: room_code}}, socket}
  end

  @impl true
  def handle_in("shout", %{"body" => body}, socket) do
    broadcast(socket, "shout", %{
      body: body,
      room: socket.assigns[:room]
    })

    {:noreply, socket}
  end
end
