defmodule Songapp.Rooms.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :code, :string
    field :date, :time
    field :password, :string
    field :language, :string
    field :rounds, :integer
    field :max_players, :integer
    field :player_admin_id, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:code, :password, :rounds, :max_players, :language, :date])
    |> validate_required([:code, :password, :rounds, :max_players, :language, :date])
  end
end
