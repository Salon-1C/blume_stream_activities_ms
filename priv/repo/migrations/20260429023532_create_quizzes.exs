defmodule StreamActivities.Repo.Migrations.CreateQuizzes do
  use Ecto.Migration

  def change do
    create table(:quizzes) do
      add :stream_id, :integer, null: false
      add :title,  :string, size: 255, null: false
      add :max_score, :integer, null: false
      add :status, :string, default: "draft", null: false
      add :created_at, :utc_datetime, null: false
      add :closed_at, :utc_datetime

      timestamps()
    end
  end
end
