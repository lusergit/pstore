defmodule PstoreWeb.PetControllerTest do
  use PstoreWeb.ConnCase

  import Pstore.PetsFixtures

  alias Pstore.Pets.Pet

  @create_attrs %{
    name: "some name",
    age: 42,
    breed: "some breed",
    desc: "some description",
    species: :cat
  }
  @update_attrs %{
    name: "some updated name",
    age: 43,
    breed: "some updated breed",
    desc: "some updated description",
    species: :cat
  }
  @invalid_attrs %{birthday: nil, name: nil}

  setup %{conn: conn} do
    conn = put_req_header(conn, "accept", "application/json")
    user = Pstore.AccountsFixtures.user_fixture()
    admin = Pstore.AccountsFixtures.user_fixture(admin_level: 1)
    %{conn: conn, user_conn: log_in_user(conn, user), admin_conn: log_in_user(conn, admin)}
  end

  describe "index" do
    test "lists all pets", %{conn: conn} do
      conn = get(conn, ~p"/pets")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create pet" do
    test "renders pet when data is valid", %{admin_conn: admin_conn} do
      conn = post(admin_conn, ~p"/pets", pet: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/pets/#{id}")

      assert %{
               "id" => ^id,
               "type" => "pets",
               "attributes" => %{}
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{admin_conn: admin_conn} do
      conn = post(admin_conn, ~p"/pets", pet: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update pet" do
    setup [:create_pet]

    test "renders pet when data is valid and user is admin", %{
      admin_conn: admin_conn,
      pet: %Pet{id: id} = pet
    } do
      conn = put(admin_conn, ~p"/pets/#{pet}", pet: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/pets/#{id}")

      assert %{
               "id" => ^id,
               "type" => "pets",
               "attributes" => %{
                 "name" => "some updated name"
               }
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{admin_conn: admin_conn, pet: pet} do
      conn = put(admin_conn, ~p"/pets/#{pet}", pet: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete pet" do
    setup [:create_pet]

    test "can't delete pet as normal user/unauthenticated", %{
      conn: conn,
      user_conn: user_conn,
      pet: pet
    } do
      unauthenticated = delete(conn, ~p"/pets/#{pet}")
      assert %{status: 401, state: :sent} = unauthenticated

      user_conn = delete(user_conn, ~p"/pets/#{pet}")
      assert %{status: 403, state: :sent} = user_conn
    end

    test "deletes chosen pet", %{admin_conn: admin_conn, pet: pet} do
      conn = delete(admin_conn, ~p"/pets/#{pet}")
      assert json_response(conn, 204)

      get_conn = get(admin_conn, ~p"/pets/#{pet}")
      assert json_response(get_conn, 404)
    end
  end

  defp create_pet(_) do
    pet = pet_fixture()
    %{pet: pet}
  end
end
