import Config
import Dotenvy

source!([".env"])

config :stream_activities, :jwt_secret, env!("JWT_SECRET", :string)

if System.get_env("PHX_SERVER") do
  config :stream_activities, StreamActivitiesWeb.Endpoint, server: true
end

config :stream_activities, StreamActivitiesWeb.Endpoint,
       http: [port: String.to_integer(System.get_env("PORT", "4000"))]

# --- START OF LIBCLUSTER CONFIGURATION ---
# This runs in both dev and prod
if config_env() in [:dev, :prod] do
  cluster_nodes_env = System.get_env("CLUSTER_NODES") || ""

  cluster_nodes =
    cluster_nodes_env
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&String.to_atom/1)

  if cluster_nodes != [] do
    config :libcluster,
           topologies: [
             phoenix_cluster: [
               strategy: Cluster.Strategy.Epmd,
               config: [hosts: cluster_nodes]
             ]
           ]
  end
end
# --- END OF LIBCLUSTER CONFIGURATION ---

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  maybe_ipv6 = if System.get_env("ECTO_IPV6") in ~w(true 1), do: [:inet6], else: []

  config :stream_activities, StreamActivities.Repo,
         # ssl: true,
         url: database_url,
         pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
           # For machines with several cores, consider starting multiple pools of `pool_size`
           # pool_count: 4,
         socket_options: maybe_ipv6

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("PHX_HOST") || "example.com"

  config :stream_activities, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")

  port = String.to_integer(System.get_env("PORT", "4000"))

  config :stream_activities, StreamActivitiesWeb.Endpoint,
         url: [host: host, port: 443, scheme: "https"],
         http: [
           # IPv4 all interfaces — works beautifully with native Tailscale
           ip: {0, 0, 0, 0},
           port: port
         ],
         secret_key_base: secret_key_base
end