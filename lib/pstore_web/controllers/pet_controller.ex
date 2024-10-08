defmodule PstoreWeb.PetController do
  use PstoreWeb, :controller

  alias Pstore.Pets
  alias Pstore.Pets.Pet

  action_fallback PstoreWeb.FallbackController

  def index(conn, params) do
    filters = Map.get(params, "filter", [])
    sorts = List.wrap(Map.get(params, "sort"))

    with {:ok, pets} <- Pets.list_pets(filters, sorts) do
      render(conn, :index, pets: pets)
    end
  end

  def create(conn, %{"pet" => pet_params}) do
    with {:ok, %Pet{} = pet} <- Pets.create_pet(pet_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/pets/#{pet}")
      |> render(:show, pet: pet)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, %Pet{} = pet} <- Pets.fetch_pet(id) do
      render(conn, :show, pet: pet)
    end
  end

  def update(conn, %{"id" => id, "pet" => pet_params}) do
    with {:ok, %Pet{} = pet} <- Pets.fetch_pet(id),
         {:ok, %Pet{} = pet} <- Pets.update_pet(pet, pet_params) do
      render(conn, :show, pet: pet)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Pet{} = pet} <- Pets.fetch_pet(id),
         {:ok, %Pet{}} <- Pets.delete_pet(pet) do
      conn
      |> put_status(:no_content)
      |> render(:deleted, pet: pet)
    end
  end
end
