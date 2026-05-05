defmodule StreamActivities.Repo.Migrations.AddUsernameToChatMessages do
  use Ecto.Migration

  def change do
    alter table(:chat_messages) do
      add :username, :string, null: false
    end
  end
end
