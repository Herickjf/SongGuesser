defmodule Sq.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SqWeb.Telemetry,
      Sq.Repo,
      {DNSCluster, query: Application.get_env(:sq, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Sq.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Sq.Finch},
      # Start a worker by calling: Sq.Worker.start_link(arg)
      # {Sq.Worker, arg},
      # Start to serve requests, typically the last entry
      SqWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sq.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SqWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
