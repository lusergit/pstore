defmodule PstoreWeb.PetController do
  use PstoreWeb, :controller

  alias Pstore.Pets
  alias Pstore.Pets.Pet

  action_fallback PstoreWeb.FallbackController

  def index(conn, _params) do
    pets = Pets.list_pets()
    render(conn, :index, pets: pets)
  end

  def create(conn, %{"pet" => pet_params}) do
    with {:ok, %Pet{} = pet} <- Pets.create_pet(pet_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/pets/#{pet}")
      |> render(:show, pet: pet)
    end
  end

  def show(conn, %{"id" => id}) do
    pet = Pets.get_pet!(id)
    render(conn, :show, pet: pet)
  end

  def update(conn, %{"id" => id, "pet" => pet_params}) do
    pet = Pets.get_pet!(id)

    with {:ok, %Pet{} = pet} <- Pets.update_pet(pet, pet_params) do
      render(conn, :show, pet: pet)
    end
  end

  def delete(conn, %{"id" => id}) do
    pet = Pets.get_pet!(id)

    with {:ok, %Pet{}} <- Pets.delete_pet(pet) do
      send_resp(conn, :no_content, "")
    end
  end
end
