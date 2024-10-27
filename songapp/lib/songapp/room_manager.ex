defmodule Songapp.RoomsManager do
  alias Songapp.Game

  def create_room(params) do
    IO.inspect(params)

    case Game.create_room(%{
           code: Integer.to_string(:rand.uniform(100_000)),
           status: "waiting",
           password: params[:password],
           max_players: params[:max_players],
           language: params[:language],
           current_round_number: 0,
           round_word: nil,
           max_rounds: params[:max_rounds]
         }) do
      {:ok, room} ->
        {:ok, room}

      {:error, changeset} ->
        # Extrair os erros e retorná-los de forma amigável
        errors =
          Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
            # Formata as mensagens de erro
            Enum.reduce(opts, msg, fn {key, value}, acc ->
              String.replace(acc, "%{#{key}}", to_string(value))
            end)
          end)

        {:error, %{errors: errors}}
    end
  end

  def join_room(room_code, password, nickname, photo_id) do
    case Game.get_room_by_code!(room_code) do
      nil ->
        {:error, "Room not found on database"}

      room ->
              if room.password != password do
                {:error, "Incorrect password"}
              else
                case Game.create_player(%{
                       nickname: nickname,
                       photo_id: photo_id,
                       game_id: room.id,
                       score: 0,
                       status: "waiting"
                     }) do
                  {:ok, player} ->
                    {:ok, player, room}

                  {:error, _reason} ->
                    {:error, "Failed to join room"}
                end
              end
    end
  end

end
