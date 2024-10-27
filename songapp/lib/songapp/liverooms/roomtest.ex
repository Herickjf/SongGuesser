defmodule Songapp.Liverooms.Roomtest do
  use Ecto.Schema
  import Ecto.Changeset

  schema "room" do
    field :code, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(roomtest, attrs) do
    roomtest
    |> cast(attrs, [:code])
    |> validate_required([:code])
  end
end
