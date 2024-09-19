defmodule Pstore.Repo do
  use Ecto.Repo,
    otp_app: :pstore,
    adapter: Ecto.Adapters.Postgres

  @doc """
  Fetch interface for queries.

  Returns `{:ok, data}' if the  query succeedes, {:error, :not_found} otherwise

  ## Example
      iex(1)> Repo.fetch(%Struct{}, 123)
      {:ok, struct}

      iex(2)> Repo.fetch(%Struct{}, 456) # but no struct has id 456
      {:error, :not_found}
  """
  def fetch(query, id, opts \\ []) do
    case get(query, id, opts) do
      nil -> {:error, :not_found}
      pet -> {:ok, pet}
    end
  end

  @doc """
  Fetch by interface for queries.

  Returns `{:ok, data}' if the  query succeedes, {:error, :not_found} otherwise

  ## Example
      iex(1)> Repo.fetch_by(%Struct{}, clauses)
      {:ok, struct}

      iex(2)> Repo.fetch(%Struct{}, invalid_clauses)
      {:error, :not_found}
  """
  def fetch_by(query, clauses, opts \\ []) do
    case get_by(query, clauses, opts) do
      nil -> {:error, :not_found}
      pet -> {:ok, pet}
    end
  end
end
