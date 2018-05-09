defmodule TCP.Client.Test do
  use ExUnit.Case
  @port 4567
  @opts host: 'localhost', port: @port, timeout: 5000


  describe "when server is available" do
    setup [:start_server, :start_client]

    test "send a message", %{pid: pid} do
      assert :ok = TCP.Client.send(pid, "msg")
    end

    test "close", %{pid: pid} do
      assert :ok = TCP.Client.close(pid)
    end
  end

  describe "when server is unavailable" do
    setup [:start_client]
    test "send a message", %{pid: pid} do
      assert {:error, :closed} = TCP.Client.send(pid, "msg")
    end
  end

  defp start_client(_context) do
    {:ok, pid} = TCP.Client.start_link(@opts)
    {:ok, pid: pid}
  end

  defp start_server(_context) do
    {:ok, _server_pid} = TCP.Server.start_link(port: @port, name: :test_server)
    on_exit fn ->
      :ok = TCP.Server.stop(:test_server)
    end
  end
end
