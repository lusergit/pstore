defmodule Pstore.CartsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pstore.Carts` context.
  """

  @doc """
  Generate a cart.
  """
  def cart_fixture(attrs \\ %{}) do
    {:ok, cart} =
      attrs
      |> Enum.into(%{

      })
      |> Pstore.Carts.create_cart()

    cart
  end
end
