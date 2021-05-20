defmodule Tahmeel.Scheduler.Schema do
  use Ecto.Schema

  # import Ecto.Changeset

  schema "schedule_jobs" do
    field :state, :string
    field :worker, :string
    field :inserted_at, :utc_datetime_usec
    field :errors, {:array, :map}, default: []
  end

  # @doc false
  # def changeset(order, attrs) do
  #   order
  #   |> cast(attrs, [:drop_off_address, :pick_up_address, :weight])
  #   |> validate_required([:drop_off_address, :pick_up_address, :weight])
  # end
end
