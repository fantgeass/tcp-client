defmodule TCP.Server do
  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]}
    }
  end

  def start_link([port: port]) do
    {:ok, _pid} =
      :ranch.start_listener(:tcp_server, :ranch_tcp, [port: port], TCP.Server.Protocol, [])
  end
end

defmodule TCP.Server.Protocol do
  @behaviour :ranch_protocol
  @timeout 30000
  require Logger

  def start_link(ref, socket, transport, _opts) do
    pid = spawn_link(__MODULE__, :init, [ref, socket, transport])
    {:ok, pid}
  end

  def init(ref, socket, transport) do
    :ok = :ranch.accept_ack(ref)

    loop(socket, transport)
  end

  defp loop(socket, transport) do
    case transport.recv(socket, 0, @timeout) do
      {:ok, data} ->
        Logger.info("RECV DATA: #{data}")
        loop(socket, transport)

      {:error, reason} ->
        Logger.info("ERROR: #{reason}")
        transport.close(socket)
    end
  end
end
