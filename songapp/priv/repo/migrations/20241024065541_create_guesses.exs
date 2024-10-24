defmodule Songapp.Repo.Migrations.CreateGuesses do
  use Ecto.Migration

  def change do
    create table(:guesses) do
      add :guess, :string
      add :is_correct, :boolean, default: false, null: false
      add :"default=false", :string
      add :player_id, references(:players, on_delete: :nothing)
      add :game_id, references(:rooms, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:guesses, [:player_id])
    create index(:guesses, [:game_id])
  end
end
