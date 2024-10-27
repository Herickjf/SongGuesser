defmodule Songapp.Repo.Migrations.CreateGuesses do
  use Ecto.Migration

  def change do
    create table(:guesses) do
      add :artist, :string
      add :song_name, :string
      add :is_correct, :boolean, default: nil
      add :player_id, references(:players, on_delete: :delete_all)  # Foreign key to players
      add :game_id, references(:rooms, on_delete: :delete_all)      # Foreign key to games/rooms
      add :round_number, :integer
      add :selected_music_id, :integer, default: nil

      timestamps(type: :utc_datetime)
    end

    create index(:guesses, [:player_id])
    create index(:guesses, [:game_id])
  end
end
