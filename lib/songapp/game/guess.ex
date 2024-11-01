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
  |> cast(attrs, [
       :artist,
       :song_name,
       :is_correct,
       :player_id,
       :game_id,
       :round_number,
       :selected_music_id
     ])
    |> validate_required([:artist, :song_name, :player_id, :game_id, :round_number])
  end
end
