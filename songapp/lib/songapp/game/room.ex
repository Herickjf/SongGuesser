defmodule Songapp.Game.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :code, :string
    field :status, :string, default: "waiting"
    field :password, :string
    field :language, :string
    field :max_rounds, :integer, default: 3
    field :max_players, :integer, default: 5
    field :player_admin_id, :integer, default: nil
    field :current_round_number, :integer, default: 0
    field :round_word, :string, default: nil

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:code, :password, :language, :max_rounds, :max_players, :player_admin_id, :status, :current_round_number, :round_word])
    |> validate_required([:code, :password, :language, :max_rounds, :max_players, :player_admin_id, :status, :current_round_number])
  end
end
