defmodule Pstore.Pets do
  @moduledoc """
  The Pets context.
  """

  import Ecto.Query, warn: false
  alias Pstore.Repo

  alias Pstore.Pets.Pet

  @doc """
  Returns the list of pets.

  ## Examples

      iex> list_pets()
      [%Pet{}, ...]

  """
  def list_pets do
    Repo.all(Pet)
  end

  def list_pets(filters, sorts) do
    pets =
      Pet
      |> filter(filters)
      |> sort(sorts)
      |> Repo.all()

    {:ok, List.wrap(pets)}
  end

  defp with_breed(query, breed) do
    where(query, [p], p.breed == ^breed)
  end

  defp with_species(query, species) do
    where(query, [p], p.species == ^species)
  end

  defp with_age(query, age) do
    where(query, [p], p.age == ^age)
  end

  defp filter(query, args) do
    Enum.reduce(args, query, fn {key, val}, last ->
      case key do
        "species" -> with_species(last, val)
        "breed" -> with_breed(last, val)
        "age" -> with_age(last, val)
        _ -> last
      end
    end)
  end

  defp sort(query, keys) when is_list(keys) do
    desc_keys =
      keys
      |> Enum.filter(&String.starts_with?(&1, "-"))
      |> Enum.map(&String.replace_prefix(&1, "-", ""))

    asc_keys = keys |> Enum.filter(&(not String.starts_with?(&1, "-")))

    new_order =
      Enum.reduce(desc_keys, query, fn key, last ->
        order_by(last, [], desc: ^String.to_existing_atom(key))
      end)

    Enum.reduce(asc_keys, new_order, fn key, last ->
      order_by(last, [], ^String.to_existing_atom(key))
    end)

    # Enum.reduce(keys, query, fn key, last ->
    #   if String.starts_with?(key, "-") do
    #     ob = String.replace(key, "-", "")
    #     order_by(last, [p], desc: ^String.to_existing_atom(ob))
    #   else
    #     order_by(last, [p], ^String.to_existing_atom(key))
    #   end
    # end)
  end

  @doc """
  Gets a single pet.

  Raises `Ecto.NoResultsError` if the Pet does not exist.

  ## Examples

      iex> get_pet!(123)
      %Pet{}

      iex> get_pet!(456)
      ** (Ecto.NoResultsError)

  """
  def get_pet!(id), do: Repo.get!(Pet, id)

  def fetch_pet(id), do: Repo.fetch(Pet, id)

  def fetch_by_pet(clauses), do: Repo.fetch_by(Pet, clauses)

  @doc """
  Creates a pet.

  ## Examples

      iex> create_pet(%{field: value})
      {:ok, %Pet{}}

      iex> create_pet(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pet(attrs \\ %{}) do
    %Pet{}
    |> Pet.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a pet.

  ## Examples

      iex> update_pet(pet, %{field: new_value})
      {:ok, %Pet{}}

      iex> update_pet(pet, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pet(%Pet{} = pet, attrs) do
    pet
    |> Pet.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a pet.

  ## Examples

      iex> delete_pet(pet)
      {:ok, %Pet{}}

      iex> delete_pet(pet)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pet(%Pet{} = pet) do
    Repo.delete(pet)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pet changes.

  ## Examples

      iex> change_pet(pet)
      %Ecto.Changeset{data: %Pet{}}

  """
  def change_pet(%Pet{} = pet, attrs \\ %{}) do
    Pet.changeset(pet, attrs)
  end
end
