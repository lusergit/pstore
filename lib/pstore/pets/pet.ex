defmodule Pstore.Pets.Pet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pets" do
    field :name, :string
    field :desc, :string
    field :age, :integer
    field :species, Ecto.Enum, values: [:cat, :dog]
    field :breed, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(pet, attrs) do
    pet
    |> cast(attrs, [:name, :age, :species, :breed, :desc])
    |> validate_required([:name, :age, :species, :breed, :desc])
  end
end
