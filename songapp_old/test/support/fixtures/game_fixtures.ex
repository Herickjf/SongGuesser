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
        date: ~U[2024-10-23 06:48:00Z],
        default=0: "some default=0",
        default=waiting: "some default=waiting",
        language: "some language",
        max_players: 42,
        max_rounds: 42,
        password: "some password",
        player_admin_id: 42,
        status: "some status"
      })
      |> Songapp.Game.create_room()

    room
  end

  @doc """
  Generate a player.
  """
  def player_fixture(attrs \\ %{}) do
    {:ok, player} =
      attrs
      |> Enum.into(%{
        default=0: "some default=0",
        default=active: "some default=active",
        nickname: "some nickname",
        photo_id: "some photo_id",
        score: 42,
        status: "some status"
      })
      |> Songapp.Game.create_player()

    player
  end

  @doc """
  Generate a guess.
  """
  def guess_fixture(attrs \\ %{}) do
    {:ok, guess} =
      attrs
      |> Enum.into(%{
        default=false: "some default=false",
        guess: "some guess",
        is_correct: true
      })
      |> Songapp.Game.create_guess()

    guess
  end
end
