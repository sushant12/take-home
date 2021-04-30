defmodule Tahmeel.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :drop_off_address, :string
      add :pick_up_address, :string
      add :weight, :float

      timestamps(type: :utc_datetime)
    end

  end
end
