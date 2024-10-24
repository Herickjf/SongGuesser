defmodule Songapp.RoomsTest do
  use Songapp.DataCase

  alias Songapp.Rooms

  describe "rooms" do
    alias Songapp.Rooms.Game

    import Songapp.RoomsFixtures

    @invalid_attrs %{code: nil, date: nil, password: nil, language: nil, rounds: nil, max_players: nil}

    test "list_rooms/0 returns all rooms" do
      game = game_fixture()
      assert Rooms.list_rooms() == [game]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      assert Rooms.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game" do
      valid_attrs = %{code: "some code", date: ~T[14:00:00], password: "some password", language: "some language", rounds: 42, max_players: 42}

      assert {:ok, %Game{} = game} = Rooms.create_game(valid_attrs)
      assert game.code == "some code"
      assert game.date == ~T[14:00:00]
      assert game.password == "some password"
      assert game.language == "some language"
      assert game.rounds == 42
      assert game.max_players == 42
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rooms.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()
      update_attrs = %{code: "some updated code", date: ~T[15:01:01], password: "some updated password", language: "some updated language", rounds: 43, max_players: 43}

      assert {:ok, %Game{} = game} = Rooms.update_game(game, update_attrs)
      assert game.code == "some updated code"
      assert game.date == ~T[15:01:01]
      assert game.password == "some updated password"
      assert game.language == "some updated language"
      assert game.rounds == 43
      assert game.max_players == 43
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = Rooms.update_game(game, @invalid_attrs)
      assert game == Rooms.get_game!(game.id)
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = Rooms.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> Rooms.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = Rooms.change_game(game)
    end
  end
end
