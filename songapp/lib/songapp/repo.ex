defmodule Songapp.Repo do
  use Ecto.Repo,
    otp_app: :songapp,
    adapter: Ecto.Adapters.Postgres
end
