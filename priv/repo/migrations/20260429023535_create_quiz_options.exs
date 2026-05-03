defmodule StreamActivities.Repo.Migrations.CreateQuizOptions do
  use Ecto.Migration

  def change do
    create table(:quiz_options) do
      add :question_id, references(:quiz_questions, on_delete: :delete_all), null: false
      add :description, :text, null: false
      add :is_correct,  :boolean, null: false
      add :position, :integer, null: false
    end
  end
end
