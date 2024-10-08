defmodule Pstore.Carts do
  @moduledoc """
  The Carts context.
  """

  import Ecto.Query, warn: false
  alias Pstore.Repo

  alias Pstore.Carts.Cart
  alias Pstore.Accounts.User
  alias Pstore.Pets.Pet

  @doc """
  Returns the list of carts.

  ## Examples

      iex> list_carts()
      [%Cart{}, ...]

  """
  def list_carts do
    Repo.all(Cart)
  end

  @doc """
  Gets a single cart.

  Raises `Ecto.NoResultsError` if the Cart does not exist.

  ## Examples

      iex> get_cart!(123)
      %Cart{}

      iex> get_cart!(456)
      ** (Ecto.NoResultsError)

  """
  def get_cart!(id), do: Repo.get!(Cart, id)

  @doc """
  Gets a single cart.

  ## Examples

      iex> fetch_cart!(123)
      {:ok, %Cart{}}

      iex> fetch_cart!(456)
      {:error, :not_found}

  """
  def fetch_cart(id), do: Repo.fetch(Cart, id)

  @doc """
  Creates a cart.

  ## Examples

      iex> create_cart(%{field: value})
      {:ok, %Cart{}}

      iex> create_cart(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_cart(attrs \\ %{}) do
    %Cart{}
    |> Cart.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a cart.

  ## Examples

      iex> update_cart(cart, %{field: new_value})
      {:ok, %Cart{}}

      iex> update_cart(cart, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_cart(%Cart{} = cart, attrs) do
    cart
    |> Cart.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a cart.

  ## Examples

      iex> delete_cart(cart)
      {:ok, %Cart{}}

      iex> delete_cart(cart)
      {:error, %Ecto.Changeset{}}

  """
  def delete_cart(%Cart{} = cart) do
    Repo.delete(cart)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking cart changes.

  ## Examples

      iex> change_cart(cart)
      %Ecto.Changeset{data: %Cart{}}

  """
  def change_cart(%Cart{} = cart, attrs \\ %{}) do
    Cart.changeset(cart, attrs)
  end

  @doc """
  Creates an empty cart for the given user.

  ## Examples
      iex> new_cart_for(%User{})
      %Cart{}

  """
  def new_cart_for(%User{} = user) do
    %Cart{user_id: user.id}
    |> Ecto.Changeset.change()
    |> Repo.insert!()
  end

  @doc """
  Returns the current cart for the given user.

  ## Examples

      iex> open_cart_for(%User{})
      %Cart{}
  """
  def open_cart_for(%User{} = user) do
    query =
      from c in Cart,
        where:
          c.user_id == ^user.id and
            is_nil(c.completed_on)

    case Repo.one(query) do
      nil -> new_cart_for(user)
      x -> x
    end
  end

  def add_to_cart(%Cart{} = cart, %Pet{} = pet) do
    cart_id = cart.id

    with :ok <- can_add_to_cart(cart_id, pet.cart_id) do
      result =
        pet
        |> Ecto.Changeset.change(%{cart_id: cart_id})
        |> Pstore.Repo.update!()

      {:ok, result}
    end
  end

  def add_to_cart(%User{} = user, %Pet{} = pet) do
    user
    |> open_cart_for
    |> add_to_cart(pet)
  end

  defp can_add_to_cart(_, nil), do: :ok
  defp can_add_to_cart(current_cart, current_cart), do: {:error, :already_in_cart}
  defp can_add_to_cart(_, _), do: {:error, :forbidden}

  def checkout(%Cart{} = cart, opts \\ []) do
    defaults = [force_refetch: false]
    opts = Keyword.validate!(opts, defaults)

    case empty?(cart, opts) do
      true ->
        {:error, :bad_request}

      false ->
        update_cart(cart, %{completed_on: DateTime.now!("Etc/UTC")})
    end
  end

  def empty?(%Cart{} = cart, opts \\ []) do
    defaults = [force_refetch: false]
    opts = Keyword.validate!(opts, defaults)

    cart
    |> Repo.preload(:pets, force: opts[:force_refetch])
    |> do_is_empty?()
  end

  defp do_is_empty?(%Cart{pets: []}), do: true
  defp do_is_empty?(_), do: false

  def empty(%Cart{} = cart) do
    from(p in Pet, where: p.cart_id == ^cart.id)
    |> Repo.update_all(set: [cart_id: nil])
  end

  def gift_pet(%Pet{} = pet, %User{} = recipient) do
    Repo.transact(fn ->
      now = DateTime.now!("Etc/UTC")

      with {:ok, cart_to} <-
             %Cart{user_id: recipient.id}
             |> Cart.changeset(%{completed_on: now})
             |> Repo.insert() do
        pet
        |> Ecto.Changeset.change(cart_id: cart_to.id)
        |> Repo.update do
        end
      end
    end)
  end
end
