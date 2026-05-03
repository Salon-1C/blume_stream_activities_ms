defmodule StreamActivities.Quizzes.QuizAttempt do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "quiz_attempts" do
    field :user_id, :integer
    field :score, :integer
    field :submitted_at, :utc_datetime

    belongs_to :quiz, StreamActivities.Quizzes.Quiz
    has_many :answers, StreamActivities.Quizzes.QuizAnswer

    timestamps()
  end

  def changeset(attempt, attrs) do
    attempt
    |> cast(attrs, [:user_id, :quiz_id, :score, :submitted_at])
    |> validate_required([:user_id, :quiz_id, :score])
    |> unique_constraint([:quiz_id, :user_id])  # mirrors the DB unique index
    |> validate_number(:score, greater_than_or_equal_to: 0)
  end
end
