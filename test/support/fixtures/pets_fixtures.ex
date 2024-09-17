defmodule Pstore.PetsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pstore.Pets` context.
  """

  @doc """
  Generate a pet.
  """
  def pet_fixture(attrs \\ %{}) do
    {:ok, pet} =
      attrs
      |> Enum.into(%{
        age: 42,
        breed: "some breed",
        desc: "some desc",
        name: "some name",
        species: :cat
      })
      |> Pstore.Pets.create_pet()

    pet
  end
end
