defmodule Pstore.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PstoreWeb.Telemetry,
      Pstore.Repo,
      {DNSCluster, query: Application.get_env(:pstore, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Pstore.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Pstore.Finch},
      # Start a worker by calling: Pstore.Worker.start_link(arg)
      # {Pstore.Worker, arg},
      # Start to serve requests, typically the last entry
      PstoreWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pstore.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PstoreWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
