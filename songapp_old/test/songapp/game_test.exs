defmodule Songapp.GameTest do
  use Songapp.DataCase

  alias Songapp.Game

  describe "rooms" do
    alias Songapp.Game.Room

    import Songapp.GameFixtures

    @invalid_attrs %{code: nil, status: nil, date: nil, password: nil, language: nil, max_rounds: nil, max_players: nil, player_admin_id: nil, "default=waiting": nil, current_round_number: nil, "default=0": nil}

    test "list_rooms/0 returns all rooms" do
      room = room_fixture()
      assert Game.list_rooms() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      assert Game.get_room!(room.id) == room
    end

    test "create_room/1 with valid data creates a room" do
      valid_attrs = %{code: "some code", status: "some status", date: ~U[2024-10-23 06:48:00Z], password: "some password", language: "some language", max_rounds: 42, max_players: 42, player_admin_id: 42, "default=waiting": "some default=waiting", current_round_number: 42, "default=0": "some default=0"}

      assert {:ok, %Room{} = room} = Game.create_room(valid_attrs)
      assert room.code == "some code"
      assert room.status == "some status"
      assert room.date == ~U[2024-10-23 06:48:00Z]
      assert room.password == "some password"
      assert room.language == "some language"
      assert room.max_rounds == 42
      assert room.max_players == 42
      assert room.player_admin_id == 42
      assert room.default=waiting == "some default=waiting"
      assert room.current_round_number == 42
      assert room.default=0 == "some default=0"
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Game.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()
      update_attrs = %{code: "some updated code", status: "some updated status", date: ~U[2024-10-24 06:48:00Z], password: "some updated password", language: "some updated language", max_rounds: 43, max_players: 43, player_admin_id: 43, "default=waiting": "some updated default=waiting", current_round_number: 43, "default=0": "some updated default=0"}

      assert {:ok, %Room{} = room} = Game.update_room(room, update_attrs)
      assert room.code == "some updated code"
      assert room.status == "some updated status"
      assert room.date == ~U[2024-10-24 06:48:00Z]
      assert room.password == "some updated password"
      assert room.language == "some updated language"
      assert room.max_rounds == 43
      assert room.max_players == 43
      assert room.player_admin_id == 43
      assert room.default=waiting == "some updated default=waiting"
      assert room.current_round_number == 43
      assert room.default=0 == "some updated default=0"
    end

    test "update_room/2 with invalid data returns error changeset" do
      room = room_fixture()
      assert {:error, %Ecto.Changeset{}} = Game.update_room(room, @invalid_attrs)
      assert room == Game.get_room!(room.id)
    end

    test "delete_room/1 deletes the room" do
      room = room_fixture()
      assert {:ok, %Room{}} = Game.delete_room(room)
      assert_raise Ecto.NoResultsError, fn -> Game.get_room!(room.id) end
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = Game.change_room(room)
    end
  end

  describe "players" do
    alias Songapp.Game.Player

    import Songapp.GameFixtures

    @invalid_attrs %{status: nil, nickname: nil, photo_id: nil, score: nil, "default=0": nil, "default=active": nil}

    test "list_players/0 returns all players" do
      player = player_fixture()
      assert Game.list_players() == [player]
    end

    test "get_player!/1 returns the player with given id" do
      player = player_fixture()
      assert Game.get_player!(player.id) == player
    end

    test "create_player/1 with valid data creates a player" do
      valid_attrs = %{status: "some status", nickname: "some nickname", photo_id: "some photo_id", score: 42, "default=0": "some default=0", "default=active": "some default=active"}

      assert {:ok, %Player{} = player} = Game.create_player(valid_attrs)
      assert player.status == "some status"
      assert player.nickname == "some nickname"
      assert player.photo_id == "some photo_id"
      assert player.score == 42
      assert player.default=0 == "some default=0"
      assert player.default=active == "some default=active"
    end

    test "create_player/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Game.create_player(@invalid_attrs)
    end

    test "update_player/2 with valid data updates the player" do
      player = player_fixture()
      update_attrs = %{status: "some updated status", nickname: "some updated nickname", photo_id: "some updated photo_id", score: 43, "default=0": "some updated default=0", "default=active": "some updated default=active"}

      assert {:ok, %Player{} = player} = Game.update_player(player, update_attrs)
      assert player.status == "some updated status"
      assert player.nickname == "some updated nickname"
      assert player.photo_id == "some updated photo_id"
      assert player.score == 43
      assert player.default=0 == "some updated default=0"
      assert player.default=active == "some updated default=active"
    end

    test "update_player/2 with invalid data returns error changeset" do
      player = player_fixture()
      assert {:error, %Ecto.Changeset{}} = Game.update_player(player, @invalid_attrs)
      assert player == Game.get_player!(player.id)
    end

    test "delete_player/1 deletes the player" do
      player = player_fixture()
      assert {:ok, %Player{}} = Game.delete_player(player)
      assert_raise Ecto.NoResultsError, fn -> Game.get_player!(player.id) end
    end

    test "change_player/1 returns a player changeset" do
      player = player_fixture()
      assert %Ecto.Changeset{} = Game.change_player(player)
    end
  end

  describe "guesses" do
    alias Songapp.Game.Guess

    import Songapp.GameFixtures

    @invalid_attrs %{guess: nil, is_correct: nil, "default=false": nil}

    test "list_guesses/0 returns all guesses" do
      guess = guess_fixture()
      assert Game.list_guesses() == [guess]
    end

    test "get_guess!/1 returns the guess with given id" do
      guess = guess_fixture()
      assert Game.get_guess!(guess.id) == guess
    end

    test "create_guess/1 with valid data creates a guess" do
      valid_attrs = %{guess: "some guess", is_correct: true, "default=false": "some default=false"}

      assert {:ok, %Guess{} = guess} = Game.create_guess(valid_attrs)
      assert guess.guess == "some guess"
      assert guess.is_correct == true
      assert guess.default=false == "some default=false"
    end

    test "create_guess/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Game.create_guess(@invalid_attrs)
    end

    test "update_guess/2 with valid data updates the guess" do
      guess = guess_fixture()
      update_attrs = %{guess: "some updated guess", is_correct: false, "default=false": "some updated default=false"}

      assert {:ok, %Guess{} = guess} = Game.update_guess(guess, update_attrs)
      assert guess.guess == "some updated guess"
      assert guess.is_correct == false
      assert guess.default=false == "some updated default=false"
    end

    test "update_guess/2 with invalid data returns error changeset" do
      guess = guess_fixture()
      assert {:error, %Ecto.Changeset{}} = Game.update_guess(guess, @invalid_attrs)
      assert guess == Game.get_guess!(guess.id)
    end

    test "delete_guess/1 deletes the guess" do
      guess = guess_fixture()
      assert {:ok, %Guess{}} = Game.delete_guess(guess)
      assert_raise Ecto.NoResultsError, fn -> Game.get_guess!(guess.id) end
    end

    test "change_guess/1 returns a guess changeset" do
      guess = guess_fixture()
      assert %Ecto.Changeset{} = Game.change_guess(guess)
    end
  end
end
