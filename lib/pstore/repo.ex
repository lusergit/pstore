defmodule Pstore.Repo do
  use Ecto.Repo,
    otp_app: :pstore,
    adapter: Ecto.Adapters.Postgres
end
