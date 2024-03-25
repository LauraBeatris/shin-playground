defmodule ShinPlayground.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ShinPlaygroundWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:shin_playground, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ShinPlayground.PubSub},
      # Start a worker by calling: ShinPlayground.Worker.start_link(arg)
      # {ShinPlayground.Worker, arg},
      # Start to serve requests, typically the last entry
      ShinPlaygroundWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ShinPlayground.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ShinPlaygroundWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
