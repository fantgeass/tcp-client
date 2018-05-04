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
      {:connection, "~> 1.0"},
      {:poolboy, "~> 1.5.1"},
      {:ranch, "~> 1.5"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://gitexhub.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
