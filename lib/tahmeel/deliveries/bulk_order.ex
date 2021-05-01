defmodule Tahmeel.Deliveries.BulkOrder do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bulk_orders" do
    field :drop_off_addresses, {:array, :string}
    field :pick_up_addresses, {:array, :string}
    field :total_weight, :float
    field :ref_num, :string

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:drop_off_addresses, :pick_up_addresses, :total_weight, :ref_num])
    |> validate_required([:drop_off_addresses, :pick_up_addresses, :total_weight, :ref_num])
  end
end
