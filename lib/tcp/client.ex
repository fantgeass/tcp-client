defmodule TCP.Client do
  use Connection

  def start_link(params) do
    Connection.start_link(__MODULE__, params)
  end

  def send(conn, data), do: Connection.call(conn, {:send, data})

  def close(conn), do: Connection.call(conn, :close)

  # Callbacks

  def init(host: host, port: port, timeout: timeout) do
    opts = [mode: :binary, active: false]
    s = %{host: host, port: port, opts: opts, timeout: timeout, sock: nil}
    {:connect, :init, s}
  end

  def connect(_info, %{host: host, port: port, opts: opts, timeout: timeout, sock: nil} = s) do
    case :gen_tcp.connect(host, port, opts, timeout) do
      {:ok, sock} ->
        {:ok, %{s | sock: sock}}

      {:error, _reason} ->
        {:backoff, 5000, s}
    end
  end

  def disconnect(_info, %{sock: sock} = s) do
    :ok = :gen_tcp.close(sock)

    {:connect, :reconnect, %{s | sock: nil}}
  end

  # not connected yet
  def handle_call(_request, _from, %{sock: nil} = s) do
    {:reply, {:error, :closed}, s}
  end

  def handle_call({:send, data}, _from, %{sock: sock} = s) do
    case :gen_tcp.send(sock, data) do
      :ok ->
        {:reply, :ok, s}

      {:error, _} = error ->
        {:disconnect, error, error, s}
    end
  end

  def handle_call(:close, from, s) do
    Connection.reply(from, :ok)
    {:disconnect, {:close, from}, s}
  end
end
