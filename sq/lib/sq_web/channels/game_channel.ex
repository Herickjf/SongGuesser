defmodule SqWeb.GameChannel do
  use SqWeb, :channel

  def join("game:" <> _room_id, %{"nickname" => nickname}, socket) do
    socket = assign(socket, :nickname, nickname)
    {:ok, socket}
  end


  def handle_in("submit_music", %{"music" => music}, socket) do
    broadcast!(socket, "new_submission", %{"nickname" => socket.assigns.nickname, "music" => music})
    {:noreply, socket}
  end
end
