defmodule Tahmeel.DeliveriesTest do
  use Tahmeel.DataCase

  alias Tahmeel.Deliveries

  describe "orders" do
    alias Tahmeel.Deliveries.Order

    @valid_attrs %{drop_off_address: "some drop_off_address", pick_up_address: "some pick_up_address", weight: 120.5}
    @update_attrs %{drop_off_address: "some updated drop_off_address", pick_up_address: "some updated pick_up_address", weight: 456.7}
    @invalid_attrs %{drop_off_address: nil, pick_up_address: nil, weight: nil}

    def order_fixture(attrs \\ %{}) do
      {:ok, order} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Deliveries.create_order()

      order
    end

    test "list_orders/0 returns all orders" do
      order = order_fixture()
      assert Deliveries.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert Deliveries.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      assert {:ok, %Order{} = order} = Deliveries.create_order(@valid_attrs)
      assert order.drop_off_address == "some drop_off_address"
      assert order.pick_up_address == "some pick_up_address"
      assert order.weight == 120.5
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Deliveries.create_order(@invalid_attrs)
    end

    test "update_order/2 with valid data updates the order" do
      order = order_fixture()
      assert {:ok, %Order{} = order} = Deliveries.update_order(order, @update_attrs)
      assert order.drop_off_address == "some updated drop_off_address"
      assert order.pick_up_address == "some updated pick_up_address"
      assert order.weight == 456.7
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = order_fixture()
      assert {:error, %Ecto.Changeset{}} = Deliveries.update_order(order, @invalid_attrs)
      assert order == Deliveries.get_order!(order.id)
    end

    test "delete_order/1 deletes the order" do
      order = order_fixture()
      assert {:ok, %Order{}} = Deliveries.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> Deliveries.get_order!(order.id) end
    end

    test "change_order/1 returns a order changeset" do
      order = order_fixture()
      assert %Ecto.Changeset{} = Deliveries.change_order(order)
    end
  end
end
