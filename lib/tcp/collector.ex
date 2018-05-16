defmodule TCP.Collector do
  use GenStage

  @spec start_link(args :: [], opts :: [name: atom]) :: {:ok, pid}
  def start_link(args \\ [], opts \\ [name: __MODULE__]) do
    GenStage.start_link(__MODULE__, args, opts)
  end

  @spec send(message :: String.t, pid :: atom) :: no_return
  def send(message \\ "MESSAGE", pid \\ __MODULE__) do
    GenStage.cast(pid, {:send, message})
  end

  # Callbacks

  def init(_opts) do
    {:producer, []}
  end

  def handle_cast({:send, message}, s) do
    {:noreply, [message], s}
  end

  def handle_demand(_demand, state) do
    {:noreply, [], state}
  end
end
