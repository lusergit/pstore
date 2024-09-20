defmodule Pstore.Carts.Cart do
  use Ecto.Schema
  import Ecto.Changeset

  schema "carts" do

    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(cart, attrs) do
    cart
    |> cast(attrs, [])
    |> validate_required([])
  end
end
