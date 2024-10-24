defmodule Songapp.Game.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :code, :string
    field :status, :string, default: "waiting"
    field :password, :string
    field :language, :string
    field :max_rounds, :integer
    field :max_players, :integer
    field :player_admin_id, :integer
    field :current_round_number, :integer, default: 0
    field :round_word, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:code, :password, :language, :max_rounds, :max_players, :player_admin_id, :status, :"default=waiting", :date, :current_round_number, :"default=0"])
    |> validate_required([:code, :password, :language, :max_rounds, :max_players, :player_admin_id, :status, :"default=waiting", :date, :current_round_number, :"default=0"])
  end
end
