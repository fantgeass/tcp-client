defmodule TCP.Client.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    sender_opts = [host: 'localhost', port: 5678, timeout: 5000, retry: 5]
    children = [
      {TCP.Collector, []},
      Supervisor.child_spec({TCP.Sender, sender_opts}, id: 1),
      Supervisor.child_spec({TCP.Sender, sender_opts}, id: 2),
    ]

    Supervisor.init(children, [strategy: :one_for_one])
  end
end
