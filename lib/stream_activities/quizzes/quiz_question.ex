defmodule StreamActivities.Quizzes.QuizQuestion do
  use Ecto.Schema
  import Ecto.Changeset

  schema "quiz_questions" do
    field :question, :string
    field :display_order, :integer
    field :points, :integer

    belongs_to :quiz, StreamActivities.Quizzes.Quiz
    has_many :options, StreamActivities.Quizzes.QuizOption
    has_many :answers, StreamActivities.Quizzes.QuizAnswer
  end

  def changeset(question, attrs) do
    question
    |> cast(attrs, [:question, :display_order, :points, :quiz_id])
    |> validate_required([:question, :display_order, :points, :quiz_id])
    |> validate_number(:points, greater_than: 0)
  end
end

