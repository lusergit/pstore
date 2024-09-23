defmodule Pstore.Carts.Cart do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pstore.Pets.Pet
  alias Pstore.Accounts.User

  schema "carts" do
    field :completed_on, :utc_datetime

    belongs_to :user, User
    has_many :pets, Pet

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(cart, attrs) do
    cart
    |> cast(attrs, [:user_id, :completed_on])
    |> validate_required([:user_id])
  end
end
