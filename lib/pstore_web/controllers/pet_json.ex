defmodule PstoreWeb.PetJSON do
  alias Pstore.Pets.Pet

  @doc """
  Renders a list of pets.
  """
  def index(%{pets: pets}) do
    %{data: for(pet <- pets, do: data(pet))}
  end

  @doc """
  Renders a single pet.
  """
  def show(%{pet: pet}) do
    %{data: data(pet)}
  end

  def deleted(%{pet: pet}) do
    %{
      status: "ok",
      deleted_pet: data(pet)
    }
  end

  def data(%Pet{} = pet) do
    %{
      type: "pets",
      id: pet.id,
      attributes: %{
        name: pet.name,
        age: pet.age,
        species: pet.species,
        breed: pet.breed,
        desc: pet.desc
      }
    }
  end
end
