defmodule Songapp.Game.Player do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:nickname, :photo_id, :score, :status, :is_admin]}

  schema "players" do
    field :nickname, :string
    field :photo_id, :integer
    field :score, :integer, default: 0
    field :status, :string, default: "ready"
    field :is_admin, :boolean, default: false
    field :game_id, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:nickname, :photo_id, :score, :status, :is_admin, :game_id])  # Adicionado :is_admin
    |> validate_required([:nickname, :photo_id, :game_id])  # Corrigido
  end
end
