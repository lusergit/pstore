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
      |> put_resp_header("location", ~p"/pets/#{pet}")
      |> render(:show, pet: pet)
    end
  end

  def show(conn, %{"id" => id}) do
    case Pets.get_pet(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(json: PstoreWeb.ErrorJSON)
        |> render(:"404")

      pet ->
        render(conn, :show, pet: pet)
    end
  end

  def update(conn, %{"id" => id, "pet" => pet_params}) do
    case Pets.get_pet(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(json: PstoreWeb.ErrorJSON)
        |> render(:"404")

      pet ->
        with {:ok, %Pet{} = pet_to_up} <- Pets.update_pet(pet, pet_params) do
          render(conn, :show, pet: pet_to_up)
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    case Pets.get_pet(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(json: PstoreWeb.ErrorJSON)
        |> render(:"404")

      pet ->
        with {:ok, %Pet{}} <- Pets.delete_pet(pet) do
          send_resp(conn, :no_content, "")
        end
    end
  end
end
