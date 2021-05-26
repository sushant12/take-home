defmodule Tahmeel.Scheduler.ConfigTest do
  use ExUnit.Case
  alias Tahmeel.Scheduler.Config

  describe "new/1" do
    test "should return a new Config struct with valid opts" do
      assert %Config{cron: [{"* * * * *", FakeModule}]} =
               Config.new(cron: [{"* * * * *", FakeModule}])
    end

    test "should raise when invalid worker module is passed" do
      assert_raise RuntimeError, fn ->
        Config.new(cron: [{"* * * * *", InvalidModule}])
      end
    end

    test "should raise when invalid option is passed" do
      assert_raise FunctionClauseError, fn ->
        Config.new(invalid: [{"* * * * *", FakeModule}])
      end
    end
  end
end

defmodule FakeModule do
  def run, do: :ok
end
