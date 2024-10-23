defmodule MultiplayerGameWeb.RoomSocket do
  use Phoenix.Socket

  ## Channels
  channel "room:lobby", MultiplayerGameWeb.RoomChannel

  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
