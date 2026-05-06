defmodule StreamActivities.Polls.PollOption do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "poll_options" do
    field :description, :string
    field :final_vote_count, :integer
    field :final_percentage, :decimal

    belongs_to :poll, StreamActivities.Polls.Polls
  end

  def changeset(option, attrs) do
    option
    |> cast(attrs, [:description, :poll_id])
    |> validate_required([:description, :poll_id])
  end

end
