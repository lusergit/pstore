defmodule Pstore.CartsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pstore.Carts` context.
  """

  @doc """
  Generate a cart.
  """
  def cart_fixture(attrs \\ %{}) do
    user_id =
      attrs[:user_id] ||
        Pstore.AccountsFixtures.user_fixture().id

    {:ok, cart} =
      attrs
      |> Enum.into(%{
        user_id: user_id
      })
      |> Pstore.Carts.create_cart()

    cart
  end
end
