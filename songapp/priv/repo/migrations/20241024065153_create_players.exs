defmodule Songapp.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :nickname, :string
      add :photo_id, :string
      add :score, :integer
      add :"default=0", :string
      add :status, :string
      add :"default=active", :string
      add :game_id, references(:rooms, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:players, [:game_id])
  end
end
