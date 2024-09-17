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

  defp data(%Pet{} = pet) do
    %{
      id: pet.id,
      name: pet.name,
      age: pet.age,
      species: pet.species,
      breed: pet.breed,
      desc: pet.desc
    }
  end
end
