defmodule MultiplayerGameWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:lobby", _payload, socket) do
    {:ok, socket}
  end

  def handle_in("create_room", %{"room_name" => room_name}, socket) do
    # Aqui você pode armazenar as salas em memória, por exemplo, num GenServer ou ETS
    broadcast!(socket, "room_created", %{"room_name" => room_name})
    {:noreply, socket}
  end

  def handle_in("join_room", %{"room_name" => room_name}, socket) do
    # Aqui você pode implementar lógica para adicionar jogadores à sala
    broadcast!(socket, "joined_room", %{"room_name" => room_name})
    {:noreply, socket}
  end
end
