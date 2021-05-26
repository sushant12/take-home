defmodule Tahmeel.Scheduler.CronTest do
  use Tahmeel.DataCase
  alias Tahmeel.Scheduler.Cron
  alias Tahmeel.Scheduler.Cron.Expression
  alias Tahmeel.Scheduler.Config

  describe "init/1" do
    test "should parse cron expression" do
      cron_tab = {Expression.parse!("* * * * *"), FakeModule}

      assert {:ok,
              %Cron.State{
                conf: %Config{cron: [{"* * * * *", FakeModule}]},
                crontab: [cron_tab]
              },
              {:continue, :schedule}} == Cron.init([%Config{cron: [{"* * * * *", FakeModule}]}])
    end
  end

  describe "handle_info :evaluate" do
    test "should insert into database" do
      state = %Cron.State{
        conf: %Config{cron: [{"* * * * *", FakeModule}]},
        crontab: [{Expression.parse!("* * * * *"), FakeModule}]
      }

      Cron.handle_info(:evaluate, state)
      assert Repo.all(Tahmeel.Scheduler.Schema) |> Enum.count() == 1
    end
  end
end
