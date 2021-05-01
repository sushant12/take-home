defmodule Tahmeel.Repo.Migrations.CreatePackages do
  use Ecto.Migration

  def change do
    create table(:packages) do
      add :drop_off_address, :string
      add :pick_up_address, :string
      add :weight, :float

      timestamps()
    end

  end
end
