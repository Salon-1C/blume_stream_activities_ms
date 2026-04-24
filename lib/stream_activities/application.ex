defmodule StreamActivities.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      StreamActivitiesWeb.Telemetry,
      StreamActivities.Repo,
      {DNSCluster, query: Application.get_env(:stream_activities, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: StreamActivities.PubSub},
      # Start a worker by calling: StreamActivities.Worker.start_link(arg)
      # {StreamActivities.Worker, arg},
      # Start to serve requests, typically the last entry
      StreamActivitiesWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: StreamActivities.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    StreamActivitiesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
