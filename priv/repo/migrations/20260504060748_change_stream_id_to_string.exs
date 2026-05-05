defmodule StreamActivities.Repo.Migrations.ChangeStreamIdToString do
  use Ecto.Migration

  def change do
    alter table(:chat_messages) do
      modify :stream_id, :string
    end

    alter table(:polls) do
      modify :stream_id, :string
    end

    alter table(:quizzes) do
      modify :stream_id, :string
    end
  end
end
