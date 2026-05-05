defmodule StreamActivities.Repo.Migrations.ChangeUserIdToString do
  use Ecto.Migration

  def change do
    alter table(:chat_messages) do
      modify :sender_id, :string
    end

    alter table(:poll_votes) do
      modify :user_id, :string
    end

    alter table(:quiz_attempts) do
      modify :user_id, :string
    end
  end
end
