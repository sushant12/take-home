defmodule Tahmeel.Repo.Migrations.CreateBulkOrderTable do
  use Ecto.Migration

  def change do
    create table(:bulk_orders) do
      add :drop_off_addresses, {:array, :string}
      add :pick_up_addresses, {:array, :string}
      add :total_weight, :float
      add :ref_num, :string
      timestamps()
    end
  end
end
