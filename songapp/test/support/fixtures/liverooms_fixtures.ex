defmodule Songapp.LiveroomsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Songapp.Liverooms` context.
  """

  @doc """
  Generate a roomtest.
  """
  def roomtest_fixture(attrs \\ %{}) do
    {:ok, roomtest} =
      attrs
      |> Enum.into(%{
        code: "some code"
      })
      |> Songapp.Liverooms.create_roomtest()

    roomtest
  end
end
