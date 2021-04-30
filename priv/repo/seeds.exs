# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Tahmeel.Repo.insert!(%Tahmeel.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Tahmeel.Deliveries

Deliveries.create_order(%{
  pick_up_address: "address 1",
  drop_off_address: "address 2",
  weight: 12.04
})

Deliveries.create_order(%{
  pick_up_address: "address 3",
  drop_off_address: "address 4",
  weight: 12.04
})

Deliveries.create_order(%{
  pick_up_address: "address 5",
  drop_off_address: "address 5",
  weight: 12.04
})

%Deliveries.Order{
  pick_up_address: "address 7",
  drop_off_address: "address 8",
  weight: 12.04,
  inserted_at: DateTime.utc_now() |> DateTime.add(-86400)
}
|> Tahmeel.Repo.insert()
