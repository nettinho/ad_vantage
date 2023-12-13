defmodule AdVantage.Repo do
  use Ecto.Repo,
    otp_app: :ad_vantage,
    adapter: Ecto.Adapters.Postgres
end
