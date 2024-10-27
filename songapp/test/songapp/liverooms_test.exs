defmodule Songapp.LiveroomsTest do
  use Songapp.DataCase

  alias Songapp.Liverooms

  describe "room" do
    alias Songapp.Liverooms.Roomtest

    import Songapp.LiveroomsFixtures

    @invalid_attrs %{code: nil}

    test "list_room/0 returns all room" do
      roomtest = roomtest_fixture()
      assert Liverooms.list_room() == [roomtest]
    end

    test "get_roomtest!/1 returns the roomtest with given id" do
      roomtest = roomtest_fixture()
      assert Liverooms.get_roomtest!(roomtest.id) == roomtest
    end

    test "create_roomtest/1 with valid data creates a roomtest" do
      valid_attrs = %{code: "some code"}

      assert {:ok, %Roomtest{} = roomtest} = Liverooms.create_roomtest(valid_attrs)
      assert roomtest.code == "some code"
    end

    test "create_roomtest/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Liverooms.create_roomtest(@invalid_attrs)
    end

    test "update_roomtest/2 with valid data updates the roomtest" do
      roomtest = roomtest_fixture()
      update_attrs = %{code: "some updated code"}

      assert {:ok, %Roomtest{} = roomtest} = Liverooms.update_roomtest(roomtest, update_attrs)
      assert roomtest.code == "some updated code"
    end

    test "update_roomtest/2 with invalid data returns error changeset" do
      roomtest = roomtest_fixture()
      assert {:error, %Ecto.Changeset{}} = Liverooms.update_roomtest(roomtest, @invalid_attrs)
      assert roomtest == Liverooms.get_roomtest!(roomtest.id)
    end

    test "delete_roomtest/1 deletes the roomtest" do
      roomtest = roomtest_fixture()
      assert {:ok, %Roomtest{}} = Liverooms.delete_roomtest(roomtest)
      assert_raise Ecto.NoResultsError, fn -> Liverooms.get_roomtest!(roomtest.id) end
    end

    test "change_roomtest/1 returns a roomtest changeset" do
      roomtest = roomtest_fixture()
      assert %Ecto.Changeset{} = Liverooms.change_roomtest(roomtest)
    end
  end
end
