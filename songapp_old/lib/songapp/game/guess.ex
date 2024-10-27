defmodule Songapp.Game.Guess do
  use Ecto.Schema
  import Ecto.Changeset

  schema "guesses" do
    field :artist, :string
    field :song_name, :string
    field :is_correct, :boolean, default: nil
    field :player_id, :integer
    field :game_id, :integer
    field :round_number, :integer
    field :selected_music_id, :integer, default: nil

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(guess, attrs) do
    guess
    |> cast(attrs, [:guess, :is_correct, :"default=false"])
    |> validate_required([:guess, :is_correct, :"default=false"])
  end
end
