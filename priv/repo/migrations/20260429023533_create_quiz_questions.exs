defmodule StreamActivities.Repo.Migrations.CreateQuizQuestions do
  use Ecto.Migration

  def change do
    create table(:quiz_questions) do
      add :display_order, :integer, null: false
      add :quiz_id, references(:quizzes, on_delete: :delete_all), null: false
      add :question, :text, null: false
      add :points, :integer, null: false
    end
  end
end
