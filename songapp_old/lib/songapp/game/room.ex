defmodule Songapp.Game.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :code, :string
    field :status, :string, default: "waiting"
    field :password, :string
    field :language, :string, default: "en"
    field :max_rounds, :integer, default: 3
    field :max_players, :integer, default: 5
    field :current_round_number, :integer, default: 0
    field :round_word, :string, default: nil

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:code, :password, :language, :max_rounds, :max_players, :status, :current_round_number, :round_word])
    |> validate_required([:code, :password])
  end
end
