defmodule StreamActivities.Quizzes.Quiz do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "quizzes" do
    field :title, :string
    field :stream_id, :integer
    field :status, :string, default: "open"
    field :max_score, :integer
    field :closed_at, :utc_datetime

    has_many :questions, StreamActivities.Quizzes.QuizQuestion
    has_many :attempts, StreamActivities.Quizzes.QuizAttempt

    timestamps()
  end

  def changeset(quiz, attrs) do
    quiz
    |> cast(attrs, [:title, :stream_id, :status, :max_score])
    |> validate_required([:title, :stream_id, :max_score])
    |> validate_inclusion(:status, ["draft", "open", "paused", "closed"])
    |> validate_number(:max_score, greater_than: 0)
  end
end