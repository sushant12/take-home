defmodule Tahmeel.DeliveriesTest do
  use Tahmeel.DataCase

  import Mock

  alias Tahmeel.Deliveries

  describe "packages" do
    alias Tahmeel.Deliveries.Package

    def create_package1 do
      {:ok, package} =
        %Package{
          pick_up_address: "address 4",
          drop_off_address: "address 7",
          weight: 12.04,
          inserted_at:
            NaiveDateTime.utc_now()
            |> NaiveDateTime.add(-86400)
            |> NaiveDateTime.truncate(:second)
        }
        |> Tahmeel.Repo.insert()

      package
    end

    def create_package2 do
      {:ok, package} =
        %Package{
          pick_up_address: "address 5",
          drop_off_address: "address 6",
          weight: 12.04,
          inserted_at:
            NaiveDateTime.utc_now()
            |> NaiveDateTime.add(-86400)
            |> NaiveDateTime.truncate(:second)
        }
        |> Tahmeel.Repo.insert()

      package
    end

    test "create_package/1 with valid data creates a package" do
      assert {:ok, %Package{} = package} =
               Deliveries.create_package(%{
                 drop_off_address: "some drop_off_address",
                 pick_up_address: "some pick_up_address",
                 weight: 120.5
               })

      assert package.drop_off_address == "some drop_off_address"
      assert package.pick_up_address == "some pick_up_address"
      assert package.weight == 120.5
    end

    test "create_package/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Deliveries.create_package(%{
                 drop_off_address: nil,
                 pick_up_address: nil,
                 weight: nil
               })
    end

    test "get_packages_to_be_delivered/0 returns those packages whose order were placed before midnight(12AM UTC)" do
      Deliveries.create_package(%{
        drop_off_address: "some drop_off_address",
        pick_up_address: "some pick_up_address",
        weight: 120.5
      })

      package1 = create_package1()
      package2 = create_package2()

      assert Deliveries.get_packages_to_be_delivered() == [package1, package2]
    end

    test "get_packages_to_be_delivered/0 should return empty list if there are no order placed before midnight(12AM UTC)" do
      Deliveries.create_package(%{
        drop_off_address: "some drop_off_address",
        pick_up_address: "some pick_up_address",
        weight: 120.5
      })

      assert Deliveries.get_packages_to_be_delivered() == []
    end

    test "gather_packages/1 will gather packages for bulk order" do
      create_package1()
      create_package2()

      with_mock(Tahmeel.Utils, random_short_id: fn -> "ABC" end) do
        assert Deliveries.get_packages_to_be_delivered() |> Deliveries.gather_packages() == %{
                 pick_up_addresses: ["address 5", "address 4"],
                 drop_off_addresses: ["address 6", "address 7"],
                 total_weight: 24.08,
                 ref_num: "PK-ABC"
               }
      end
    end

    test "gather_packages/1 with empty list will return empty map" do
      assert Deliveries.get_packages_to_be_delivered() |> Deliveries.gather_packages() == %{}
    end
  end
end
