defmodule PstoreWeb.CartController do
  use PstoreWeb, :controller

  alias Pstore.Carts
  alias Pstore.Carts.Cart
  alias Pstore.Pets
  alias Pstore.Accounts

  action_fallback PstoreWeb.FallbackController

  def index(conn, _params) do
    carts = Carts.list_carts()
    render(conn, :index, carts: carts)
  end

  def show(conn, %{"id" => id}) do
    with {:ok, %Cart{} = cart} <- Carts.fetch_cart(id) do
      render(conn, :show, cart: cart)
    end
  end

  def show_open(conn, %{"id" => user_id}) do
    with {:ok, target} <- Accounts.fetch_user(user_id),
         :ok <-
           Bodyguard.permit(
             PstoreWeb.Authorization,
             :access_cart,
             conn.assigns.current_user,
             target
           ),
         cart = Carts.open_cart_for(target),
         do: render(conn, :show, cart: cart)
  end

  def add_to_cart(conn, %{"id" => pet_id}) do
    user = conn.assigns.current_user
    cart = Carts.open_cart_for(user)

    with {:ok, pet} <- Pets.fetch_pet(pet_id),
         {:ok, _new_pet} <- Carts.add_to_cart(cart, pet) do
      render(conn, :show, cart: cart)
    end
  end

  def checkout(conn, _params) do
    user = conn.assigns.current_user
    cart = Carts.open_cart_for(user)

    with {:ok, cart} <- Carts.checkout(cart) do
      render(conn, :show, cart: cart)
    end
  end

  def empty_by_open(conn, _params),
    do:
      conn.assigns.current_user
      |> Carts.open_cart_for()
      |> do_empty_cart(conn)

  def empty_by_id(conn, %{"id" => cart_id}) do
    with {:ok, cart} <- Carts.fetch_cart(cart_id),
         :ok <- validate_open_cart(cart),
         {:ok, owner} <- Accounts.fetch_user(cart.user_id),
         :ok <-
           Bodyguard.permit(
             PstoreWeb.Authorization,
             :access_cart,
             conn.assigns.current_user,
             owner
           ) do
      do_empty_cart(cart, conn)
    end
  end

  defp do_empty_cart(cart, conn) do
    Carts.empty(cart)
    cart = Pstore.Repo.preload(cart, :pets, force: true)
    render(conn, :show, cart: cart)
  end

  defp validate_open_cart(cart) do
    if cart.completed_on,
      do: {:error, :forbidden},
      else: :ok
  end
end
