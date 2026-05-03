defmodule StreamActivities.Repo.Migrations.CreateQuizAnswers do
  use Ecto.Migration

  def change do
    create table(:quiz_answers) do
      add :attempt_id, references(:quiz_attempts, on_delete: :delete_all), null: false
      add :quiz_question_id, references(:quiz_questions, on_delete: :delete_all), null: false
      add :quiz_option_id, references(:quiz_options, on_delete: :delete_all), null: false
      add :is_correct, :boolean, null: false
      add :points_earned, :integer, null: false
    end
  end
end
