defmodule Songapp.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :code, :string
      add :password, :string
      add :language, :string
      add :max_rounds, :integer
      add :max_players, :integer
      add :player_admin_id, :integer
      add :status, :string
      add :"default=waiting", :string
      add :date, :utc_datetime
      add :current_round_number, :integer
      add :"default=0", :string

      timestamps(type: :utc_datetime)
    end
  end
end
