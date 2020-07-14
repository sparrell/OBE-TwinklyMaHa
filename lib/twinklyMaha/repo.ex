defmodule TwinklyMaha.Repo do
  use Ecto.Repo,
    otp_app: :twinklyMaha,
    adapter: Ecto.Adapters.Postgres
end
