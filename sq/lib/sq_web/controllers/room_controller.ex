defmodule SqWeb.RoomController do
  use SqWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, %{"room_code" => room_code, "password" => password}) do
    # Lógica para criar sala com senha
    json(conn, %{"message" => "Sala criada", "room_code" => room_code})
  end

  def join(conn, %{"room_code" => room_code, "password" => password}) do
    # Lógica para verificar a senha e entrar na sala
    json(conn, %{"message" => "Entrou na sala", "room_code" => room_code})
  end
end
