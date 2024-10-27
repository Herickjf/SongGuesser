defmodule Songapp.Liverooms do
  @moduledoc """
  The Liverooms context.
  """

  import Ecto.Query, warn: false
  alias Songapp.Repo

  alias Songapp.Liverooms.Roomtest

  @doc """
  Returns the list of room.

  ## Examples

      iex> list_room()
      [%Roomtest{}, ...]

  """
  def list_room do
    Repo.all(Roomtest)
  end

  @doc """
  Gets a single roomtest.

  Raises `Ecto.NoResultsError` if the Roomtest does not exist.

  ## Examples

      iex> get_roomtest!(123)
      %Roomtest{}

      iex> get_roomtest!(456)
      ** (Ecto.NoResultsError)

  """
  def get_roomtest!(id), do: Repo.get!(Roomtest, id)

  @doc """
  Creates a roomtest.

  ## Examples

      iex> create_roomtest(%{field: value})
      {:ok, %Roomtest{}}

      iex> create_roomtest(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_roomtest(attrs \\ %{}) do
    %Roomtest{}
    |> Roomtest.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a roomtest.

  ## Examples

      iex> update_roomtest(roomtest, %{field: new_value})
      {:ok, %Roomtest{}}

      iex> update_roomtest(roomtest, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_roomtest(%Roomtest{} = roomtest, attrs) do
    roomtest
    |> Roomtest.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a roomtest.

  ## Examples

      iex> delete_roomtest(roomtest)
      {:ok, %Roomtest{}}

      iex> delete_roomtest(roomtest)
      {:error, %Ecto.Changeset{}}

  """
  def delete_roomtest(%Roomtest{} = roomtest) do
    Repo.delete(roomtest)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking roomtest changes.

  ## Examples

      iex> change_roomtest(roomtest)
      %Ecto.Changeset{data: %Roomtest{}}

  """
  def change_roomtest(%Roomtest{} = roomtest, attrs \\ %{}) do
    Roomtest.changeset(roomtest, attrs)
  end
end
