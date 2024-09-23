# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Pstore.Repo.insert!(%Pstore.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

case Mix.env() do
  :dev ->
    Pstore.Accounts.register_user(%{email: "root@root.com", password: "adminpw", admin_level: 1})

  # other migration options to populate the db
  _ ->
    nil
end
