defmodule Songapp.Game.Player do
  use Ecto.Schema
  import Ecto.Changeset

  schema "players" do
    field :nickname, :string
    field :photo_id, :integer
    field :score, :integer, default: 0
    field :status, :string, default: "ready"
    belongs_to :game, Songapp.Game.Room # Relaciona com o jogo

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:nickname, :photo_id, :score, :status, :game_id])  # Corrigido
    |> validate_required([:nickname, :photo_id, :game_id])  # Corrigido
  end
end
