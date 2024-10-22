defmodule Sq.Repo do
  use Ecto.Repo,
    otp_app: :sq,
    adapter: Ecto.Adapters.Postgres
end
