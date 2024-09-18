defmodule Pstore.Pets.Pet do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc false

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
    |> validate_required([:name, :age, :species, :breed])
    |> unique_constraint(:name)
    |> validate_number(:age, greater_than: 0)
    |> validate_length(:name, min: 0)
    |> validate_length(:breed, min: 0)
  end
end
