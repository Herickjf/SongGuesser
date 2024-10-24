defmodule Songapp.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :code, :string
      add :password, :string
      add :rounds, :integer
      add :max_players, :integer
      add :language, :string
      add :date, :time

      timestamps(type: :utc_datetime)
    end
  end
end
