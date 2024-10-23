defmodule MultiplayerGame.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MultiplayerGameWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:multiplayer_game, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MultiplayerGame.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: MultiplayerGame.Finch},
      # Start a worker by calling: MultiplayerGame.Worker.start_link(arg)
      # {MultiplayerGame.Worker, arg},
      # Start to serve requests, typically the last entry
      MultiplayerGameWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MultiplayerGame.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MultiplayerGameWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
