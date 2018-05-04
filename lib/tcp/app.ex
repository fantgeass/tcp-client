defmodule TCP.App do
  use Application

  defp poolboy_config do
    [
      {:name, {:local, :client}},
      {:worker_module, TCP.Client},
      {:size, 5},
      {:max_overflow, 2}
    ]
  end

  def start(_type, _args) do
    children = [
      :poolboy.child_spec(:worker, poolboy_config(), host: 'localhost', port: 5678, timeout: 5000)
    ]

    opts = [strategy: :one_for_one, name: TCP.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
