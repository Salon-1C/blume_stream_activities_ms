defmodule StreamActivities.Polls.Poll do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "polls" do
    field :stream_id, :integer
    field :question, :string
    field :status, :string, default: "open"
    field :is_anonymous, :boolean, default: false
    field :max_number_selections, :integer, default: 1
    field :closed_at, :utc_datetime

    has_many :options, StreamActivities.Polls.PollOption
    has_many :votes, StreamActivities.Polls.PollVote

    timestamps()
  end

  def changeset(poll, attrs) do
    poll
    |> cast(attrs, [:stream_id, :question, :status, :is_anonymous, :max_number_selections])
    |> validate_required([:stream_id, :question, :max_number_selections])
    |> validate_inclusion(:status, ["open", "closed"])
    |> validate_number(:max_number_selections, greater_than: 0)
  end
end

