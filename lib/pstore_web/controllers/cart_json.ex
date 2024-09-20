defmodule PstoreWeb.CartJSON do
  alias Pstore.Carts.Cart

  @doc """
  Renders a list of carts.
  """
  def index(%{carts: carts}) do
    %{data: for(cart <- carts, do: data(cart))}
  end

  @doc """
  Renders a single cart.
  """
  def show(%{cart: cart}) do
    %{data: data(cart)}
  end

  defp data(%Cart{} = cart) do
    %{
      id: cart.id
    }
  end
end
