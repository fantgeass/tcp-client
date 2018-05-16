defmodule TCP.Collector.Test do
  use ExUnit.Case

  test "stores messages" do
    {:ok, pid} = TCP.Collector.start_link([], [name: :test_collector])
    for _n <- 1..3, do: TCP.Collector.send("TEST", pid)

    assert ["TEST", "TEST", "TEST"] = GenStage.stream([{pid, max_demand: 10}]) |> Enum.take(3)
  end
end
