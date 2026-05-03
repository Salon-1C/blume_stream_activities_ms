defmodule StreamActivities.Repo.Migrations.CreateChatMessages do
  use Ecto.Migration

  def change do
    create table(:chat_messages) do
      add :sender_id, :integer, null: false
      add :stream_id, :integer, null: false
      add :message,   :text,    null: false
      add :sent_at, :utc_datetime, null: false

      timestamps()
    end
  end
end
