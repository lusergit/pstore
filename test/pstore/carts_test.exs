defmodule Pstore.CartsTest do
  use Pstore.DataCase

  alias Pstore.Carts

  describe "carts" do
    alias Pstore.Carts.Cart

    import Pstore.CartsFixtures

    # completed on must be a datetime
    @invalid_attrs %{completed_on: 5}

    test "list_carts/0 returns all carts" do
      cart = cart_fixture()
      assert Carts.list_carts() == [cart]
    end

    test "get_cart!/1 returns the cart with given id" do
      cart = cart_fixture()
      assert Carts.get_cart!(cart.id) == cart
    end

    test "create_cart/1 with valid data creates a cart" do
      valid_id = Pstore.AccountsFixtures.user_fixture().id
      valid_attrs = %{user_id: valid_id}

      assert {:ok, %Cart{} = cart} = Carts.create_cart(valid_attrs)
      assert(cart.user_id == valid_id)
    end

    test "create_cart/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Carts.create_cart(@invalid_attrs)
    end

    test "update_cart/2 with valid data updates the cart" do
      cart = cart_fixture()
      update_attrs = %{completed_on: ~U[2024-09-23 09:04:00Z]}

      assert {:ok, %Cart{} = cart} = Carts.update_cart(cart, update_attrs)
      assert cart.completed_on == ~U[2024-09-23 09:04:00Z]
    end

    test "update_cart/2 with invalid data returns error changeset" do
      cart = cart_fixture()
      assert {:error, %Ecto.Changeset{}} = Carts.update_cart(cart, @invalid_attrs)
      assert cart == Carts.get_cart!(cart.id)
    end

    test "delete_cart/1 deletes the cart" do
      cart = cart_fixture()
      assert {:ok, %Cart{}} = Carts.delete_cart(cart)
      assert_raise Ecto.NoResultsError, fn -> Carts.get_cart!(cart.id) end
    end

    test "change_cart/1 returns a cart changeset" do
      cart = cart_fixture()
      assert %Ecto.Changeset{} = Carts.change_cart(cart)
    end
  end
end
