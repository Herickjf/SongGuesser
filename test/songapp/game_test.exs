defmodule Songapp.GameTest do
  use Songapp.DataCase

  alias Songapp.Game

  describe "rooms" do
    alias Songapp.Game.Room

    import Songapp.GameFixtures

    @invalid_attrs %{code: nil, status: nil, password: nil, language: nil, max_rounds: nil, max_players: nil, current_round_number: nil, round_word: nil}

    test "list_rooms/0 returns all rooms" do
      room = room_fixture()
      assert Game.list_rooms() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      assert Game.get_room!(room.id) == room
    end

    test "create_room/1 with valid data creates a room" do
      valid_attrs = %{code: "some code", status: "some status", password: "some password", language: "some language", max_rounds: 42, max_players: 42, current_round_number: 42, round_word: "some round_word"}

      assert {:ok, %Room{} = room} = Game.create_room(valid_attrs)
      assert room.code == "some code"
      assert room.status == "some status"
      assert room.password == "some password"
      assert room.language == "some language"
      assert room.max_rounds == 42
      assert room.max_players == 42
      assert room.current_round_number == 42
      assert room.round_word == "some round_word"
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Game.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()
      update_attrs = %{code: "some updated code", status: "some updated status", password: "some updated password", language: "some updated language", max_rounds: 43, max_players: 43, current_round_number: 43, round_word: "some updated round_word"}

      assert {:ok, %Room{} = room} = Game.update_room(room, update_attrs)
      assert room.code == "some updated code"
      assert room.status == "some updated status"
      assert room.password == "some updated password"
      assert room.language == "some updated language"
      assert room.max_rounds == 43
      assert room.max_players == 43
      assert room.current_round_number == 43
      assert room.round_word == "some updated round_word"
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
end
