defmodule TCP.App do
  use Application

  def start(_type, _args) do
    children = [
      TCP.Server.Supervisor,
      TCP.Client.Supervisor
    ]

    Supervisor.start_link(children, [strategy: :one_for_one])
  end
end
