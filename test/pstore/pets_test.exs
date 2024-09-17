defmodule Pstore.PetsTest do
  use Pstore.DataCase

  alias Pstore.Pets

  describe "pets" do
    alias Pstore.Pets.Pet

    import Pstore.PetsFixtures

    @invalid_attrs %{name: nil, desc: nil, age: nil, species: nil, breed: nil}

    test "list_pets/0 returns all pets" do
      pet = pet_fixture()
      assert Pets.list_pets() == [pet]
    end

    test "get_pet!/1 returns the pet with given id" do
      pet = pet_fixture()
      assert Pets.get_pet!(pet.id) == pet
    end

    test "create_pet/1 with valid data creates a pet" do
      valid_attrs = %{name: "some name", desc: "some desc", age: 42, species: :cat, breed: "some breed"}

      assert {:ok, %Pet{} = pet} = Pets.create_pet(valid_attrs)
      assert pet.name == "some name"
      assert pet.desc == "some desc"
      assert pet.age == 42
      assert pet.species == :cat
      assert pet.breed == "some breed"
    end

    test "create_pet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Pets.create_pet(@invalid_attrs)
    end

    test "update_pet/2 with valid data updates the pet" do
      pet = pet_fixture()
      update_attrs = %{name: "some updated name", desc: "some updated desc", age: 43, species: :dog, breed: "some updated breed"}

      assert {:ok, %Pet{} = pet} = Pets.update_pet(pet, update_attrs)
      assert pet.name == "some updated name"
      assert pet.desc == "some updated desc"
      assert pet.age == 43
      assert pet.species == :dog
      assert pet.breed == "some updated breed"
    end

    test "update_pet/2 with invalid data returns error changeset" do
      pet = pet_fixture()
      assert {:error, %Ecto.Changeset{}} = Pets.update_pet(pet, @invalid_attrs)
      assert pet == Pets.get_pet!(pet.id)
    end

    test "delete_pet/1 deletes the pet" do
      pet = pet_fixture()
      assert {:ok, %Pet{}} = Pets.delete_pet(pet)
      assert_raise Ecto.NoResultsError, fn -> Pets.get_pet!(pet.id) end
    end

    test "change_pet/1 returns a pet changeset" do
      pet = pet_fixture()
      assert %Ecto.Changeset{} = Pets.change_pet(pet)
    end
  end
end
