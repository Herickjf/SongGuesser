defmodule Songapp.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :code, :string
      add :status, :string, default: "waiting"
      add :password, :string
      add :language, :string, default: "en"
      add :max_rounds, :integer, default: 3
      add :max_players, :integer, default: 5
      add :current_round_number, :integer, default: 0
      add :round_word, :string, default: nil

      timestamps(type: :utc_datetime)
    end

    create unique_index(:rooms, [:code]) # Ensures unique room codes
  end
end
