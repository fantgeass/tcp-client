defmodule TCP.Server.Test do
  use ExUnit.Case
  @port 4567

  test "start and stop" do
    assert {:ok, _pid} = TCP.Server.start_link(port: @port, name: :test_server)
    assert :ok = TCP.Server.stop(:test_server)
  end
end
