defmodule StreamActivities.Repo do
  use Ecto.Repo,
    otp_app: :stream_activities,
    adapter: Ecto.Adapters.Postgres
end
