defmodule Songapp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SongappWeb.Telemetry,
      Songapp.Repo,
      {DNSCluster, query: Application.get_env(:songapp, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Songapp.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Songapp.Finch},
      # Start a worker by calling: Songapp.Worker.start_link(arg)
      # {Songapp.Worker, arg},
      # Start to serve requests, typically the last entry
      SongappWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Songapp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SongappWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
