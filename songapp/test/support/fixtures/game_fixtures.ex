defmodule Songapp.GameFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Songapp.Game` context.
  """

  @doc """
  Generate a room.
  """
  def room_fixture(attrs \\ %{}) do
    {:ok, room} =
      attrs
      |> Enum.into(%{
        code: "some code",
        current_round_number: 42,
        language: "some language",
        max_players: 42,
        max_rounds: 42,
        password: "some password",
        round_word: "some round_word",
        status: "some status"
      })
      |> Songapp.Game.create_room()

    room
  end
end
