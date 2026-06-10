import Config
import Dotenvy

source!([".env"])

config :stream_activities, :jwt_secret, env!("JWT_SECRET", :string)

if System.get_env("PHX_SERVER") do
  config :stream_activities, StreamActivitiesWeb.Endpoint, server: true
end

config :stream_activities, StreamActivitiesWeb.Endpoint,
       http: [port: String.to_integer(System.get_env("PORT", "4000"))]

# ── Erlang clustering (libcluster) ────────────────────────────────────────────
# CLUSTER_NODES is a comma-separated list of node names, e.g.:
#   "activities@100.x.x.x,activities@100.y.y.y"
# When not set (local dev with mix phx.server), clustering is simply skipped.
if raw_nodes = System.get_env("CLUSTER_NODES") do
  nodes =
    raw_nodes
    |> String.split(",")
    |> Enum.map(&(&1 |> String.trim() |> String.to_atom()))

  config :libcluster,
         topologies: [
           blume_cluster: [
             strategy: Cluster.Strategy.Epmd,
             config: [hosts: nodes]
           ]
         ]
end
# ─────────────────────────────────────────────────────────────────────────────

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  maybe_ipv6 = if System.get_env("ECTO_IPV6") in ~w(true 1), do: [:inet6], else: []

  config :stream_activities, StreamActivities.Repo,
         url: database_url,
         pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
         socket_options: maybe_ipv6

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("PHX_HOST") || "example.com"


  port = String.to_integer(System.get_env("PORT", "4000"))

  config :stream_activities, StreamActivitiesWeb.Endpoint,
         url: [host: host, port: 443, scheme: "https"],
         http: [
           ip: {0, 0, 0, 0},
           port: port
         ],
         secret_key_base: secret_key_base
end