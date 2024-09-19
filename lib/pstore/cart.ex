defmodule Pstore.Cart do
  use Ecto.Schema
  import Ecto.Changeset

  schema "carts" do
    belongs_to :user, Pstore.Accounts.User
    has_many :pets, Pstore.Pets.Pet

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(cart, attrs) do
    cart
    |> Ecto.build_assoc(:pets)
    |> cast(attrs, [])
    |> validate_required([])
  end
end
