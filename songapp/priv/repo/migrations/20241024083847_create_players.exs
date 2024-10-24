defmodule Songapp.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :nickname, :string
      add :photo_id, :integer
      add :score, :integer, default: 0
      add :status, :string, default: "ready"
      add :game_id, references(:rooms, on_delete: :delete_all) # Foreign key to the game (rooms)

      timestamps(type: :utc_datetime)
    end

    create index(:players, [:game_id]) # Index for efficient querying
  end
end
