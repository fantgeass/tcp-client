defmodule TCP.Server do
  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]}
    }
  end

  @spec start_link([port: integer, name: atom]) :: {:ok, pid}
  def start_link([port: port, name: name]) do
    {:ok, _pid} =
      :ranch.start_listener(name, :ranch_tcp, [port: port], TCP.Server.Protocol, [])
  end

  @spec stop(name :: atom) :: :ok
  def stop(name) do
    :ok = :ranch.stop_listener(name)
  end
end

defmodule TCP.Server.Protocol do
  @behaviour :ranch_protocol
  @timeout 30000

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
      {:ok, _data} ->
        loop(socket, transport)
      {:error, _reason} ->
        transport.close(socket)
    end
  end
end
