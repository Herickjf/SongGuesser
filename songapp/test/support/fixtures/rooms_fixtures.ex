defmodule Songapp.RoomsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Songapp.Rooms` context.
  """

  @doc """
  Generate a game.
  """
  def game_fixture(attrs \\ %{}) do
    {:ok, game} =
      attrs
      |> Enum.into(%{
        code: "some code",
        date: ~T[14:00:00],
        language: "some language",
        max_players: 42,
        password: "some password",
        rounds: 42
      })
      |> Songapp.Rooms.create_game()

    game
  end
end
