defmodule Tahmeel.Deliveries do
  @moduledoc """
  The Deliveries context.
  """

  import Ecto.Query, warn: false
  alias Tahmeel.Repo

  alias Tahmeel.Deliveries.Package
  alias Tahmeel.Deliveries.BulkOrder

  def create_package(attrs \\ %{}) do
    %Package{}
    |> Package.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  get all packages that were placed as order yesterday
  """
  def get_packages_to_be_delivered() do
    yesterday = Date.utc_today() |> Date.add(-1)

    query = from(p in Package, where: fragment("?::date", p.inserted_at) == ^yesterday)
    Repo.all(query)
  end

  @doc """
  combines all package information into a single map
  """
  def gather_packages(packages) do
    packages
    |> Enum.reduce(%{}, fn package, bulk_order ->
      Map.merge(bulk_order, %{
        pick_up_addresses: [package.pick_up_address | Map.get(bulk_order, :pick_up_addresses, [])],
        drop_off_addresses: [
          package.drop_off_address | Map.get(bulk_order, :drop_off_addresses, [])
        ],
        total_weight: Map.get(bulk_order, :total_weight, 0) + package.weight,
        ref_num: "PK-" <> Tahmeel.Utils.random_short_id()
      })
    end)
  end

  def save_bulk_order(attrs) do
    %BulkOrder{}
    |> BulkOrder.changeset(attrs)
    |> Repo.insert()
  end
end
