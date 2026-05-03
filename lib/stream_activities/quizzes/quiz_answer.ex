defmodule StreamActivities.Quizzes.QuizAnswer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "quiz_answers" do
    field :is_correct, :boolean
    field :points_earned, :integer

    belongs_to :quiz_attempt, StreamActivities.Quizzes.QuizAttempt
    belongs_to :quiz_question, StreamActivities.Quizzes.QuizQuestion
    belongs_to :quiz_option, StreamActivities.Quizzes.QuizOption
  end

  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:attempt_id, :quiz_question_id, :quiz_option_id, :is_correct, :points_earned])
    |> validate_required([:attempt_id, :quiz_question_id, :quiz_option_id, :is_correct, :points_earned])
    |> unique_constraint([:attempt_id, :quiz_question_id])
    |> validate_number(:points_earned, greater_than_or_equal_to: 0)
  end
end