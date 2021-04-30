defmodule Tahmeel.Deliveries.Order do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts [type: :utc_datetime_usec]
  schema "orders" do
    field :drop_off_address, :string
    field :pick_up_address, :string
    field :weight, :float

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:drop_off_address, :pick_up_address, :weight])
    |> validate_required([:drop_off_address, :pick_up_address, :weight])
  end
end
