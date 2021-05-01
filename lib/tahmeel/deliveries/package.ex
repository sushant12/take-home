defmodule Tahmeel.Deliveries.Package do
  use Ecto.Schema
  import Ecto.Changeset

  schema "packages" do
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
