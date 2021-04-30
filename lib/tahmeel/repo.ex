defmodule Tahmeel.Repo do
  use Ecto.Repo,
    otp_app: :tahmeel,
    adapter: Ecto.Adapters.Postgres
end
