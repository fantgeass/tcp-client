defmodule TcpServer.MixProject do
  use Mix.Project

  def project do
    [
      app: :tcp,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {TCP.App, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ranch, "~> 1.5"},
      {:gen_stage, "~> 0.12"},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false}
    ]
  end
end
