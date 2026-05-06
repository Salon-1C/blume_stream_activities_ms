defmodule StreamActivities.Polls.PollVote do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "poll_votes" do
    field :user_id, :integer
    field :voted_at, :utc_datetime

    belongs_to :poll, StreamActivities.Polls.Polls
    belongs_to :poll_option, StreamActivities.Polls.PollOption
  end

  def changeset(vote, attrs) do
    vote
    |> cast(attrs, [:user_id, :poll_id, :poll_option_id, :voted_at])
    |> validate_required([:user_id, :poll_id, :poll_option_id])
    |> unique_constraint([:poll_option_id, :user_id])  # mirrors the DB unique index
  end
end
