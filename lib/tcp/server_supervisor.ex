defmodule TCP.Server.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    children = [
      {TCP.Server, [port: 5678]}
    ]

    Supervisor.init(children, [strategy: :one_for_one])
  end
end
