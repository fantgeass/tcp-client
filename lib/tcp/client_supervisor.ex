defmodule TCP.Client.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  defp poolboy_config do
    [
      {:name, {:local, :client}},
      {:worker_module, TCP.Client},
      {:size, 5},
      {:max_overflow, 2}
    ]
  end

  def init(_opts) do
    children = [
      :poolboy.child_spec(:worker, poolboy_config(), host: 'localhost', port: 5678, timeout: 5000)
    ]

    Supervisor.init(children, [strategy: :one_for_one])
  end
end
