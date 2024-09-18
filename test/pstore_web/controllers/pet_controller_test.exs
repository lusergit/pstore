defmodule PstoreWeb.PetControllerTest do
  use PstoreWeb.ConnCase

  import Pstore.PetsFixtures

  alias Pstore.Pets.Pet

  @create_attrs %{
    name: "some name",
    desc: "some desc",
    age: 42,
    species: :cat,
    breed: "some breed"
  }
  @update_attrs %{
    name: "some updated name",
    desc: "some updated desc",
    age: 43,
    species: :dog,
    breed: "some updated breed"
  }
  @invalid_attrs %{name: nil, desc: nil, age: nil, species: nil, breed: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all pets", %{conn: conn} do
      conn = get(conn, ~p"/pets")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create pet" do
    test "renders pet when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/pets", pet: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/pets/#{id}")

      assert %{
               "id" => ^id,
               "type" => "pets",
               "attributes" => %{
                 "age" => 42,
                 "breed" => "some breed",
                 "desc" => "some desc",
                 "name" => "some name",
                 "species" => "cat"
               }
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/pets", pet: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update pet" do
    setup [:create_pet]

    test "renders pet when data is valid", %{conn: conn, pet: %Pet{id: id} = pet} do
      conn = put(conn, ~p"/pets/#{pet}", pet: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/pets/#{id}")

      assert %{
               "id" => ^id,
               "type" => "pets",
               "attributes" => %{
                 "age" => 43,
                 "breed" => "some updated breed",
                 "desc" => "some updated desc",
                 "name" => "some updated name",
                 "species" => "dog"
               }
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, pet: pet} do
      conn = put(conn, ~p"/pets/#{pet}", pet: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete pet" do
    setup [:create_pet]

    test "deletes chosen pet", %{conn: conn, pet: pet} do
      conn = delete(conn, ~p"/pets/#{pet.id}")
      assert response(conn, 204)

      conn = get(conn, ~p"/pets/#{pet}")
      assert response(conn, 404)
    end
  end

  defp create_pet(_) do
    pet = pet_fixture()
    %{pet: pet}
  end
end
