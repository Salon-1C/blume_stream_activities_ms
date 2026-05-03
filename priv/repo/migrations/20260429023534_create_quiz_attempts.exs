defmodule StreamActivities.Repo.Migrations.CreateQuizAttempts do
  use Ecto.Migration

  def change do
    create table(:quiz_attempts) do
      add :quiz_id, references(:quizzes, on_delete: :delete_all), null: false
      add :user_id, :integer, null: false
      add :score, :integer, null: false
      add :submitted_at, :utc_datetime, null: false

      timestamps()
    end

    # at least for now, only one attempt per quiz per user
    create unique_index(:quiz_attempts, [:quiz_id, :user_id])
  end
end
