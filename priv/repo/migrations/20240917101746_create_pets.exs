defmodule Pstore.Repo.Migrations.CreatePets do
  use Ecto.Migration

  def change do
    create table(:pets) do
      add :name, :string
      add :age, :integer
      add :species, :string
      add :breed, :string
      add :desc, :string

      timestamps(type: :utc_datetime)
    end
  end
end
