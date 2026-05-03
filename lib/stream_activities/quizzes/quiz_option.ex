defmodule StreamActivities.Quizzes.QuizOption do
  use Ecto.Schema
  import Ecto.Changeset

  schema "quiz_options" do
    field :description, :string
    field :is_correct, :boolean
    field :position, :integer

    belongs_to :quiz_question, StreamActivities.Quizzes.QuizQuestion
    has_many :answers, StreamActivities.Quizzes.QuizAnswer
  end

  def changeset(question, attrs) do
    question
    |> cast(attrs, [:description, :position, :is_correct, :question_id])
    |> validate_required([:description, :position, :is_correct, :question_id])
  end
end