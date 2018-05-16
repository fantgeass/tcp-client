defmodule TCP.Sender do
  use GenStage
  require Logger

  @max_demand 5

  @spec start_link([host: charlist, port: integer, timeout: integer, retry: integer]) :: {:ok, pid}
  def start_link(opts) do
    GenStage.start_link(__MODULE__, opts)
  end

  # Callbacks

  def init(opts) do
    {:consumer, opts, subscribe_to: [{TCP.Collector, max_demand: @max_demand}]}
  end

  def handle_events(messages, _from, opts) do
    for message <- messages do
      retry_send(message, opts)
    end
    {:noreply, [], opts}
  end

  defp retry_send(message, [host: host, port: port, timeout: timeout, retry: retry]) do
    try do
      {:ok, sock} = case :gen_tcp.connect(host, port, [mode: :binary, active: false], timeout) do
        {:ok, _sock} = ok -> ok
        {:error, reason} -> raise to_string(reason)
      end

      case :gen_tcp.send(sock, message) do
        :ok -> Logger.info("#{inspect(self())} sent \"#{message}\"")
        {:error, reason} -> raise to_string(reason)
      end

      :gen_tcp.close(sock)
    rescue
      e in RuntimeError ->
        case retry do
          0 -> Logger.error("#{inspect(self())} got #{e.message}")
          _ ->
            Process.sleep(500)
            retry_send(message, [host: host, port: port, timeout: timeout, retry: retry-1])
        end
    end
  end
end